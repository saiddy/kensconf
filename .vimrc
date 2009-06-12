set helplang=cn
set encoding=utf-8
set tabstop=4       " 设置tab键的宽度
set backspace=2     " 设置退格键可用
set nu!             " 显示行号
"set wrap           " 自动换行
"set nowrap         " 不自动换行
set linebreak       " 整词换行
set whichwrap=b,s,<,>,[,]       " 光标从行首和行末时可以跳到另一行去
"set list                       " 显示制表符
"set listchars = tab:>-,trail:- " 将制表符显示为'>---',将行尾空格显示为'-'
set listchars=tab:.\ ,trail:.   " 将制表符显示为'.   '
set autochdir                   " 自动设置目录为正在编辑的文件所在的目录
set hidden          " 没有保存的缓冲区可以自动被隐藏
set scrolloff=5
set hlsearch        " 高亮显示搜索结果
set incsearch       " 查询时非常方便，如要查找book单词，当输入到/b时，会自动找到
                    " 第一个b开头的单词，当输入到/bo时，会自动找到第一个bo开头的
                    " 单词，依次类推，进行查找时，使用此设置会快速找到答案，当你
                    " 找要匹配的单词时，别忘记回车
set gdefault        " 替换时所有的行内匹配都被替换，而不是只有第一个
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set laststatus=2    " always show the status line
set ruler           " 在编辑过程中，在右下角显示光标位置的状态行
"set completeopt=longest,menu    " 关掉智能补全时的预览窗口
:set tags=/home/ken/c/tags
syn on              " 打开语法高亮
set showmatch       " 设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set smartindent     " 智能对齐方式
set shiftwidth=4    " 换行时行间交错使用4个空格
set autoindent      " 自动对齐
set ai!             " 设置自动缩进

vmap <C-c> "yy
vmap <C-x> "yd
nmap <C-v> "yp
vmap <C-v> "yp
nmap <C-a> ggvG$

nmap wv     <C-w>v     " 垂直分割当前窗口
nmap wc     <C-w>c     " 关闭当前窗口
nmap ws     <C-w>s     " 水平分割当前窗口

imap <C-s> <Esc>:wa<cr>i<Right>
nmap <C-s> :wa<cr>

syntax enable
syntax on

colorscheme desert

let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1

let g:winManagerWindowLayout='FileExplorer|TagList'

nmap wm :WMToggle<cr>
let g:ShowOutputWindowWhenVimLaunched=0

filetype plugin indent on

set completeopt=longest,menu

let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"

let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
nnoremap <silent> <F12> :A<CR>
nnoremap <silent> <F3> :Grep<CR>

let NERD_c_alt_style = 1    " 将C语言的注释符号改为//, 默认是/**/