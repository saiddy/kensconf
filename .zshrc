#!/bin/zsh
#Last Change: Fri 04 Sep 2009 10:28:49 AM EST

#------------------------listing color----------------------------------
autoload colors 
[[ $terminfo[colors] -ge 8 ]] && colors
if [[ "$TERM" == *256color ]] || [[ "$TERM" = *rxvt* ]]; then
    #use prefefined colors
    eval $(dircolors -b $HOME/.lscolor256)
else
  if [[ "$TERM" = screen ]]; then
    eval $(dircolors -b $HOME/.lscolor256)
  else
    eval $(dircolors -b $HOME/.lscolor)
  fi
fi

#---------------------------options-------------------------------------
setopt complete_aliases     #do not expand aliases _before_ completion has finished
setopt auto_cd              # if not a command, try to cd to it.
setopt auto_pushd            # automatically pushd directories on dirstack
setopt pushd_ignore_dups      # do not push dups on stack
setopt pushd_silent          # be quiet about pushds and popds
setopt brace_ccl            # expand alphabetic brace expressions
#setopt chase_links          # ~/ln -> /; cd ln; pwd -> /
setopt complete_in_word     # stays where it is and completion is done from both ends
setopt correct              # spell check for commands only
#setopt equals extended_glob # use extra globbing operators
setopt hash_list_all        # search all paths before command completion
setopt hist_ignore_all_dups     # when runing a command several times, only store one
setopt hist_reduce_blanks   # reduce whitespace in history
setopt share_history        # share history among sessions
setopt hist_verify       # reload full command when runing from history
setopt hist_expire_dups_first  #remove dups when max size reached
setopt interactive_comments # why not?
setopt list_types           # show ls -F style marks in file completion
setopt long_list_jobs       # show pid in bg job list
setopt numeric_glob_sort    # when globbing numbered files, use real counting
setopt inc_append_history   # append to history once executed

#remove / and . from WORDCHARS to allow alt-backspace to delete word
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

#replace the default beep with a message
ZBEEP="\e[?5h\e[?5l"        # visual beep
#-------------------------completion system-----------------------------
zmodload -i zsh/complist
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31' 
#ignore list in completion
zstyle ':completion:*' ignore-parents parent pwd directory
#menu selection in completion
zstyle ':completion:*' menu select=1
#zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' completer _complete _match _user_expand
zstyle ':completion:*:match:*' original only 
#zstyle ':completion:*' user-expand _pinyin
zstyle ':completion:*:approximate:*' max-errors 1 numeric 
## case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
### case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
#kill completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER' 
#use cache to speed up pacman completion
zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path .zcache 
#group matches and descriptions
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[33m == \e[1;46;33m %d \e[m\e[33m ==\e[m' 
zstyle ':completion:*:messages' format $'\e[33m == \e[1;46;33m %d \e[m\e[0;33m ==\e[m'
zstyle ':completion:*:warnings' format $'\e[33m == \e[1;47;31m No Matches Found \e[m\e[0;33m ==\e[m' 
zstyle ':completion:*:corrections' format $'\e[33m == \e[1;47;31m %d (errors: %e) \e[m\e[0;33m ==\e[m'

#autoload -U compinit
autoload -Uz compinit
compinit

#---------------------------prompt--------------------------------------
#autoload -U promptinit zmv
#promptinit
if [ "$SSH_TTY" = "" ]; then
    local host="%B%F{magenta}%m%f%b"
else
    local host="%B%F{red}%m%f%b"
fi
local user="%B%(!:%F{red}:%F{green})%n%f%b"       #different color for privileged sessions
local symbol="%B%(!:%F{red}# :%F{yellow}> )%f%b"
local job="%1(j,%F{red}:%F{blue}%j,)%f%b"
export PROMPT=$user"%F{yellow}@%f"$host$job$symbol
#export RPROMPT="%{$fg_no_bold[${1:-magenta}]%}%~%{$reset_color%}"
export RPROMPT="%F{magenta}%~%f"

# SPROMPT - the spelling prompt
export SPROMPT="%F{yellow}zsh%f: correct '%F{red}%B%R%f%b' to '%F{green}%B%r%f%b' ? ([%F{cyan}Y%f]es/[%F{cyan}N%f]o/[%F{cyan}E%f]dit/[%F{cyan}A%f]bort) "

#---------------------------history-------------------------------------
# number of lines kept in history
export HISTSIZE=10000
# number of lines saved in the history after logout
export SAVEHIST=10000
# location of history
export HISTFILE=$HOME/.zsh_history

#---------------------------alias---------------------------------------
# alias and listing colors
alias -g A="|awk"
alias -g C="|wc"
alias -g E="|sed"
alias -g G="|grep"
alias -g H="|head"
alias -g L="|less"
alias -g S="|sort"
alias -g T="|tail"
alias -g X="|xargs"

export GREP_COLOR='31;1'
alias grep='grep -I --color=always'
alias egrep='egrep -I --color=always'
alias c='clear'
alias v='vim'
alias sv='sudo vim'
alias ls='ls -h --color=auto -X --time-style="+[33m[[32m%Y-%m-%d [35m%k:%M[33m][m"'
alias vi='vim'
alias ll='ls -l'
alias la='ls -a'
alias cp='cp -vi'
alias mv='mv -vi'
alias rm='rm -vi'
alias mem='free -m'
alias X1='startx -- :1'
alias X2='startx -- :2'
alias top='htop'
alias cpuset='sudo modprobe cpufreq-nforce2 && sudo cpufreq-set -g powersave && cpufreq-info'
alias cpu='cpufreq-info'
alias sshken='ssh -l ken -p 15018 125.67.234.36'
alias sshroot='ssh -l root -p 15018 125.67.234.36'
alias gfw='ssh -qTfnN -D 7070 puff@p1.liveproxy.org'
alias qtime='qlop -Hgtv'
alias man='LANG=en_US.UTF-8 man'
alias ppstream="LD_PRELOAD='/home/ken/Downloads/ppstream/libppswrapper-preload.so.0.0.0' /home/ken/Downloads/ppstream/xpps "
alias playpps="mplayer 'http://127.0.0.1:8098'"
alias -s {jpg,JPG,jpeg,JPEG,png,PNG,gif,GIF}="qiv"
alias -s {mpg,mpeg,avi,ogm,wmv,m4v,mp4,mov,rmvb}="mplayer -idx"
alias -s {mp3,ogg,wav,flac}="mocp"
alias cman="man -M /usr/share/man/zh_CN.UTF-8/ "
alias df='df -Th'
alias music="mpd && ncmpcpp"
alias du='du -h'
alias mkdir='nocorrect mkdir'
#show directories size
alias dud='du -s *(/)'
#alias which='alias | /usr/bin/which --read-alias'
alias history='history 1'       #zsh specific
#alias mplayer='mplayer -cache 512'
alias zhcon='zhcon --utf8'
del() {mv -vif -- $* ~/.Trash}
alias m='mutt'
alias port='netstat -ntlp'      #opening ports
#alias tree="tree --dirsfirst"
alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
#alias tt="vim +'set spell' ~/doc/TODO.otl"
#alias rtm="twitter d rtm"
#alias rtorrent="screen rtorrent"
if [ -x /usr/bin/grc ]; then
    alias cl="/usr/bin/grc -es --colour=auto"
    for i in diff cat make gcc g++ as gas ld netstat ping traceroute; do
        alias $i="cl $i"
    done
fi


#-----------------user defined functions--------------------------------
#show 256 color tab
256tab() {
    for k in `seq 0 1`;do 
        for j in `seq $((16+k*18)) 36 $((196+k*18))`;do 
            for i in `seq $j $((j+17))`; do 
                printf "\e[01;$1;38;5;%sm%4s" $i $i;
            done;echo;
        done;
    done
}

#-----------------functions to set gnu screen title----------------------
# active command as title in terminals
case $TERM in
    xterm*|rxvt*)
    function title() 
    { 
        #print -nP '\e]0;'$*'\a'
        print -nPR $'\033]0;'$1$'\a'
    } ;;
    screen*)
    function title() 
    {
        #modify screen title
        print -nPR $'\033k'$1$'\033'\\
        #modify window title bar
        #print -nPR $'\033]0;'$2$'\a'
    } ;;
    *) 
    function title() {}
    ;;
esac     

#set screen title if not connected remotely
#if [ "$STY" != "" ]; then
function precmd {
    #urgent notification trigger
    #echo -ne '\a'
    #title "`print -Pn "%~" | sed "s:\([~/][^/]*\)/.*/:\1...:"`" "$TERM $PWD"
    title "`print -Pn "%~" |sed "s:\([~/][^/]*\)/.*/:\1...:;s:\([^-]*-[^-]*\)-.*:\1:"`" "$TERM $PWD"
    echo -ne '\033[?17;0;127c'
}

function preexec {
    emulate -L zsh
    local -a cmd; cmd=(${(z)1})
    if [[ $cmd[1]:t == "ssh" ]]; then
        title "@""`echo $cmd[2]|sed 's:.*@::'`" "$TERM $cmd"
    elif [[ $cmd[1]:t == "sudo" ]]; then
        title "#"$cmd[2]:t "$TERM $cmd[3,-1]"
    elif [[ $cmd[1]:t == "for" ]]; then
        title "()"$cmd[7] "$TERM $cmd"
    elif [[ $cmd[1]:t == "svn" ]]; then
        title "$cmd[1,2]" "$TERM $cmd"
    elif [[ $cmd[1]:t == "ls" ]] || [[ $cmd[1]:t == "ll" ]] ; then
    else
        title $cmd[1]:t "$TERM $cmd[2,-1]"
    fi 
}

#-----------------key bindings to fix keyboard---------------------------
#bindkey "\M-v" "\`xclip -o\`\M-\C-e\""
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
autoload -U zkbd
bindkey -e      #use emacs style keybindings :(
typeset -A key  #define an array

#if zkbd definition exists, use defined keys instead
if [[ -f ~/.zkbd/${TERM}-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
    source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
else
    key[Home]=${terminfo[khome]}
    key[End]=${terminfo[kend]}
    key[Insert]=${terminfo[kich1]}
    key[Delete]=${terminfo[kdch1]}
    key[Up]=${terminfo[kcuu1]}
    key[Down]=${terminfo[kcud1]}
    key[Left]=${terminfo[kcub1]}
    key[Right]=${terminfo[kcuf1]}
    key[PageUp]=${terminfo[kpp]}
    key[PageDown]=${terminfo[knp]}
    for k in ${(k)key} ; do
        # $terminfo[] entries are weird in ncurses application mode...
        [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
    done
fi

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

bindkey "" history-beginning-search-backward
bindkey "" history-beginning-search-forward

#-----------------user defined widgets & binds-----------------------
#from linuxtoy.org: 
#   pressing TAB in an empty command makes a cd command with completion list
dumb-cd(){
    if [[ -n $BUFFER ]] ; then # 如果该行有内容
        zle expand-or-complete # 执行 TAB 原来的功能
    else # 如果没有
        BUFFER="cd " # 填入 cd（空格）
        zle end-of-line # 这时光标在行首，移动到行末
        zle expand-or-complete # 执行 TAB 原来的功能
    fi 
}
zle -N dumb-cd
bindkey "\t" dumb-cd #将上面的功能绑定到 TAB 键

#拼音补全
function _pinyin() { reply=($($HOME/bin/chsdir 0 $*)) }

#c-z to continue as well
bindkey -s "" "fg\n"
#----------------------distro specific stuff---------------------------
if `cat /etc/issue |grep Arch >/dev/null`; then
    function command_not_found_handler() {
        echo "Man, you really need some coffee. \nA clear-headed one would not type things like \"$1\"."|cowsay -f small -W 50
        if grep Arch /etc/issue >/dev/null; then
            echo 
            pacfile /bin/$1$|awk '{split($1,a,"/");print a[1] "/\033[31m" a[2] "\033[m\t\t\t/" $2}'
        fi
        return 0
    }
fi
#----------------------variables---------------------------------------
export PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/1.8/bin
export EDITOR=vim
export VISUAL=vim

#MOST like colored man pages
export LESS_TERMCAP_md=$'\E[1;31m'      #bold1
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_me=$'\E[m'
export LESS_TERMCAP_so=$'\E[01;44;33m'  #search highlight
export LESS_TERMCAP_se=$'\E[m'
export LESS_TERMCAP_us=$'\E[1;2;32m'    #bold2
export LESS_TERMCAP_ue=$'\E[m'
export LESS="-M -i -R --shift 5"
export LESSCHARSET=utf-8
[ -x /usr/bin/src-hilite-lesspipe.sh ] && export LESSOPEN="| src-hilite-lesspipe.sh %s"

#for ConTeX
#source $HOME/.context_env /home/roylez/soft/ConTeXt/tex

#for gnuplot, avoid locate!!!
#export GDFONTPATH=$(dirname `locate DejaVuSans.ttf | tail -1`)
[[ -n $DISPLAY ]] && export GDFONTPATH=/usr/share/fonts/TTF

#for intel fortran compiler
#source $HOME/soft/intel/ifort/bin/ifortvars.sh

#ESC sudo
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
#光标移动到行末
    zle end-of-line
}
zle -N sudo-command-line
#定义快捷键为： [Esc] [Esc]
bindkey "\e\e" sudo-command-line

#export LANG=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export XMODIFIERS=@im=fcitx
export XIM=fcitx
export XIM_PROGRAM=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

#alias
alias less=/usr/share/vim/vim72/macros/less.sh
