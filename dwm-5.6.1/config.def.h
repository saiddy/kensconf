/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-microsoft yahei-medium-r-normal-*-11-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#3f3f3f";
static const char normbgcolor[]     = "#101010";
static const char normfgcolor[]     = "#777777";
static const char selbordercolor[]  = "#f0dfaf";
static const char selbgcolor[]      = "#000000";
static const char selfgcolor[]      = "#f0dfaf";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */
static const int nmaster = 2;  /* default number of clients in the master area */

/* tagging */
static const char *tags[] = { "main", "web", "code", "im", "media" };

static const Rule rules[] = {
	/* class          instance      title       tags mask     isfloating   monitor */
	{ "Gimp",           NULL,       NULL,       1 << 2,         True,        -1 },
	{ "Firefox",        NULL,       NULL,       1 << 1,         False,       -1 },
	{ "trayer",         NULL,       NULL,       1 << 3,         False,       -1 },
	{ "Thunar",         NULL,       NULL,       0,              True,        -1 },
	{ "Pidgin",         NULL,       NULL,       1 << 3,         True,        -1 },
	{ "Skype",          NULL,       NULL,       1 << 3,         True,        -1 },
        { "Stardict",       NULL,       NULL,       0,              True,        -1 },
        { "Gpicview",       NULL,       NULL,       0,              True,        -1 },
        { "Gmlive",         NULL,       NULL,       0,              True,        -1 },
        { "Eog",            NULL,       NULL,       0,              True,        -1 },
	{ "MPlayer",        NULL,       NULL,       0,              True,        -1 },
	{ "Sonata",         NULL,       NULL,       0,              True,        -1 },
	{ "Qq",             NULL,       NULL,       0,              True,        -1 },
	{ "SMPlayer",       NULL,       NULL,       0,              True,        -1 },
	{ "Gtk-chtheme",    NULL,       NULL,       0,              True,        -1 },
	{ "File-roller",    NULL,       NULL,       0,              True,        -1 },
	{ "XFontSel",       NULL,       NULL,       0,              True,        -1 },
	{  NULL,            NULL, "File Management Preferences", 0, True,        -1 },
	{  NULL,          "file_properties",  NULL, 0,              True,        -1 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = False; /* False means respect size hints in tiled resizals */

#include "bstack.c"
#include "gaplessgrid.c"
#include "nmaster.c"
#include "fibonacci.c"
#include "push.c"
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "TTT",      bstack },
	{ "###",      gaplessgrid },
        { "-|=",      ntile },
        { "-|-",      nbstack },
        { "[@]",      spiral },
        { "[\\]",     dwindle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "xterm", NULL };
static const char *rxvtcmd[]  = { "urxvt", NULL };
static const char *browsercmd[]  = { "firefox", NULL };
static const char *filecmd[]  = { "thunar", NULL };
static const char *commandcmd[]  = { "gmrun", NULL };
static const char *musicmd[]  = { "mpc", "next", NULL };
static const char *mutecmd[] = { "amixer", "-q", "sset", "Master", "toggle", NULL };
static const char *volupcmd[] = { "amixer", "-q", "sset", "Master", "2+", "unmute", NULL };
static const char *voldowncmd[] = { "amixer", "-q", "sset", "Master", "2-", "unmute", NULL };
static const char *snapshotcmd[] = { "scrot", "-d", "3", "snapshot-%Y%m%d-%H.%M.%S.png",NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_Print,  spawn,          {.v = snapshotcmd } },
	{ MODKEY,                       XK_F1,     spawn,          {.v = commandcmd } },
        { MODKEY,                       XK_F2,     spawn,          {.v = dmenucmd } },
        { MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
        { MODKEY|ControlMask,           XK_Return, spawn,          {.v = rxvtcmd } },
	{ MODKEY|ShiftMask,             XK_f,      spawn,          {.v = browsercmd } },
	{ MODKEY|ShiftMask,             XK_w,      spawn,          {.v = filecmd } },
        { MODKEY|ShiftMask,             XK_Up,     spawn,          {.v = volupcmd } },
	{ MODKEY|ShiftMask,             XK_Down,   spawn,          {.v = voldowncmd } },
	{ MODKEY|ShiftMask,             XK_Left,   spawn,          {.v = mutecmd } },
	{ MODKEY|ShiftMask,             XK_Right,  spawn,          {.v = musicmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
        { MODKEY|ControlMask,           XK_j,      pushdown,       {0} },
        { MODKEY|ControlMask,           XK_k,      pushup,         {0} },
	{ MODKEY,                       XK_Tab,    focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_q,      setlayout,      {.v = &layouts[3]} },
        { MODKEY,                       XK_g,      setlayout,      {.v = &layouts[4]} },
        { MODKEY,                       XK_w,      setlayout,      {.v = &layouts[5] } },
        { MODKEY,                       XK_e,      setlayout,      {.v = &layouts[6] } },
        { MODKEY,                       XK_s,      setlayout,      {.v = &layouts[7]} },
        { MODKEY,                       XK_c,      setlayout,      {.v = &layouts[8]} },
        { MODKEY,                       XK_a,      incnmaster,     {.i = +1} },
        { MODKEY,                       XK_z,      incnmaster,     {.i = -1} },
        { MODKEY,                       XK_x,      setnmaster,     {.i = 2} },
        { MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_BackSpace,      quit,           {0} },
};

/* button definitions */
/* click can be a tag number (starting at 0),
 * ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

