-- {{{ Header
--
-- Awesome configuration file, using awesome 3.4-git on Arch GNU/Linux.
--   * Adrian C. <anrxc_at_sysphere_org>

-- Screenshot: http://sysphere.org/gallery/snapshots

-- FAQ: 
--   1. Statusbar widgets created with Vicious:
--        - http://git.sysphere.org/vicious/

--   2. Why is there no Menu or a Taskbar in your config?
--        Everything is done with the keyboard.

--   3. Why these colors? 
--        It's Zenburn. Awesome, Emacs, Urxvt, Alpine... all use these colors.
--          - http://slinky.imukuppi.org/zenburnpage/

--      3a. My .Xdefaults can be found here: 
--            - http://git.sysphere.org/dotfiles/

--   4. Fonts used on my desktop: 
--        Terminus  : http://www.is-vn.bg/hamster
--        Profont   : http://www.tobias-jung.de/seekingprofont

-- This work is licensed under the Creative Commons Attribution-Share Alike License.
-- To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
-- User libraries
require("vicious")
require("teardrop")
-- }}}


-- {{{ Variable definitions
--
-- Zenburn theme
beautiful.init(awful.util.getdir("config") .. "/zenburn.lua")
--theme_path = os.getenv("HOME") .. "/.config/awesome/zenburn.lua"
--beautiful.init(theme_path)

-- Modifier keys
altkey = "Mod1"      -- Alt_L
modkey = "Mod4"      -- Super_L

-- Window titlebars
use_titlebar = false -- True for floaters (manage signal)

-- Window management layouts
layouts = {
    awful.layout.suit.tile,            -- 1
    awful.layout.suit.tile.left,       -- 2
    awful.layout.suit.tile.bottom,     -- 3
    awful.layout.suit.tile.top,        -- 4
    awful.layout.suit.fair,            -- 5
    awful.layout.suit.fair.horizontal, -- 6
--  awful.layout.suit.spiral,          -- /
--  awful.layout.suit.spiral.dwindle,  -- /
    awful.layout.suit.max,             -- 7
--  awful.layout.suit.max.fullscreen,  -- /
    awful.layout.suit.magnifier,       -- 8
    awful.layout.suit.floating         -- 9
}
-- }}}


-- {{{ Tags
--
-- Define tags table
tags = {}
tags.settings = {
    { name = "main",  layout = layouts[2]  },
    { name = "web",   layout = layouts[1]  },
    { name = "code",  layout = layouts[3]  },
    { name = "doc",   layout = layouts[7]  },
    { name = "im",    layout = layouts[1], mwfact = 0.75 },
    { name = "6",     layout = layouts[9], hide = true },
    { name = "7",     layout = layouts[9], hide = true },
    { name = "rss",   layout = layouts[8], hide = true },
    { name = "media", layout = layouts[9]  }
}

-- Initialize tags
for s = 1, screen.count() do
    tags[s] = {}
    for i, v in ipairs(tags.settings) do
        tags[s][i] = tag({ name = v.name })
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout", v.layout)
        awful.tag.setproperty(tags[s][i], "mwfact", v.mwfact)
        awful.tag.setproperty(tags[s][i], "hide",   v.hide)
    end
    tags[s][1].selected = true
end
-- }}}


-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separators
spacer         = widget({ type = "textbox", name = "spacer" })
separator      = widget({ type = "textbox", name = "separator" })
spacer.text    = " "
--separator.text = "//"
separator.text = '<span color="#3579a8">|</span>'
-- }}}

-- {{{ CPU usage graph and temperature
-- Widget icon
cpuicon        = widget({ type = "imagebox", name = "cpuicon" })
cpuicon.image  = image(beautiful.widget_cpu)
-- Initialize widgets
thermalwidget  = widget({ type = "textbox", name = "thermalwidget" })
cpuwidget      = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft })
cuwidget       = widget({ type = 'textbox', name = 'cuwidget' })
-- CPU graph properties
cpuwidget:set_width(30)
cpuwidget:set_height(14)
cpuwidget:set_scale(false)
cpuwidget:set_max_value(100)
cpuwidget:set_background_color(beautiful.fg_off_widget)
cpuwidget:set_border_color(beautiful.border_widget)
cpuwidget:set_color(beautiful.fg_end_widget)
cpuwidget:set_gradient_colors({
    beautiful.fg_end_widget,
    beautiful.fg_center_widget,
    beautiful.fg_widget })
-- Register widgets
vicious.register(cpuwidget, vicious.widgets.cpu, "$1", 2)
vicious.register(cuwidget, vicious.widgets.cpu, ' $1%', 10)
vicious.register(thermalwidget, vicious.widgets.thermal, "$1°C", 60, "TZS0")
-- }}}

-- {{{ Memory usage bar
-- Widget icon
memicon       = widget({ type = "imagebox", name = "memicon" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
mmwidget      = widget({ type = 'textbox', name = 'mmwidget' })
memwidget     = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft })
-- MEM progressbar properties
memwidget:set_width(25)
memwidget:set_height(11)
memwidget:set_vertical(true)
memwidget:set_background_color(beautiful.fg_off_widget)
memwidget:set_border_color(nil)
memwidget:set_color(beautiful.fg_widget)
memwidget:set_gradient_colors({
    beautiful.fg_widget,
    beautiful.fg_center_widget,
    beautiful.fg_end_widget })
awful.widget.layout.margins[memwidget.widget] = { top = 2, bottom = 2 }
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$1", 60)
vicious.register(mmwidget, vicious.widgets.mem, '$1% $2Mb/$3Mb', 10)
-- }}}

-- {{{ Network usage statistics
-- Widget icons
neticon         = widget({ type = "imagebox", name = "neticon" })
neticonup       = widget({ type = "imagebox", name = "neticonup" })
neticon.image   = image(beautiful.widget_net)
neticonup.image = image(beautiful.widget_netup)
-- Initialize widgets
netwidget       = widget({ type = "textbox", name = "netwidget" })
netfiwidget     = widget({ type = "textbox", name = "netfiwidget" })
-- Register ethernet widget
vicious.register(netwidget, vicious.widgets.net,
  '<span color="'.. beautiful.fg_netdn_widget ..'">${eth0 down_kb}</span> <span color="'
  .. beautiful.fg_netup_widget ..'">${eth0 up_kb}</span>', 2)
-- }}}

-- {{{ Mail subject (latest e-mail)
-- Widget icon
mailicon       = widget({ type = "imagebox", name = "mailicon" })
mailicon.image = image(beautiful.widget_mail)
-- Initialize widget
mboxwidget     = widget({ type = "textbox", name = "mboxwidget" })
-- Register widget
vicious.register(mboxwidget, vicious.widgets.mdir, "$1", 60, "/home/ken/Mail/Google/")
-- Register buttons
mboxwidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.util.spawn("xterm -title Mutt -e mutt", false) end)))
-- }}}

-- {{{ Volume level, progressbar and changer
-- Widget icon
volicon       = widget({ type = "imagebox", name = "volicon" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volwidget     = widget({ type = "textbox", name = "volwidget" })
volbarwidget  = awful.widget.progressbar({ layout = awful.widget.layout.horizontal.rightleft })
-- VOL progressbar properties
volbarwidget:set_width(8)
volbarwidget:set_height(10)
volbarwidget:set_vertical(true)
volbarwidget:set_background_color(beautiful.fg_off_widget)
volbarwidget:set_border_color(nil)
volbarwidget:set_color(beautiful.fg_widget)
volbarwidget:set_gradient_colors({
    beautiful.fg_widget,
    beautiful.fg_center_widget,
    beautiful.fg_end_widget })
awful.widget.layout.margins[volbarwidget.widget] = { top = 2, bottom = 2 }
-- Register widgets
vicious.register(volwidget, vicious.widgets.volume, "$1%", 2, "Master")
vicious.register(volbarwidget, vicious.widgets.volume, "$1", 2, "Master")
-- Register buttons
volbarwidget.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("xterm -title Alsamixer -e alsamixer", false) end),
    awful.button({ }, 2, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 2dB+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 2dB-", false) end)
))  volwidget:buttons( volbarwidget.widget:buttons() )
-- }}}

-- {{{ mpd. music now playing
mpdicon       = widget({ type = "imagebox", name = "mpdicon" })
mpdicon.image = image(beautiful.widget_music)
mpdwidget     = widget({ type = "textbox", name = "mpdwidget" })
vicious.register(mpdwidget,vicious.widgets.mpd,
function (widget, args)
	if args[1] == "Stopped" then
		 return ''
	 else
		 return '<span color="#daff30">MPD:</span> ' .. args[1]
	 end
 end)
mpdwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("mpc next", false) end),
	awful.button({ }, 2, function () awful.util.spawn("mpc toggle", false) end),
	awful.button({ }, 3, function () awful.util.spawn("mpc prev", false) end)
	))
-- }}}

-- {{{ Date, time and a calendar
-- Widget icon
dateicon       = widget({ type = "imagebox", name = "dateicon" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget     = widget({ type = "textbox", name = "datewidget" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%b%e, %R", 60)
-- Register buttons
datewidget:buttons(awful.util.table.join(
    -- PyLendar: http://sysphere.org/~anrxc/j/archives/2009/03/11/desktop_calendars
    awful.button({ }, 1, function () awful.util.spawn("python /home/ken/scripts/pylendar.py", false) end)))
-- }}}

-- {{{ System tray
-- Initialize widget
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev))

tasklist = {}
tasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- Add a wibox to each screen
for s = 1, screen.count() do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget with icons indicating active layout
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)

    -- Create a tasklist widget
    tasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, tasklist.buttons)

    -- Create the wibox
    wibox[s] = awful.wibox({
        position = "top", height = 16, screen = s,
        fg = beautiful.fg_normal, bg = beautiful.bg_normal
    })
    -- Add widgets to the wibox (order matters)
    wibox[s].widgets = {{
        taglist[s],
        layoutbox[s],
        promptbox[s],
        layout = awful.widget.layout.horizontal.leftright
    },
        s == screen.count() and systray or nil,
        separator,
        datewidget, dateicon,
        separator,
        volwidget, spacer, volbarwidget, volicon,
        separator,
        mboxwidget, spacer, mailicon,
        separator,
        neticonup, netwidget, neticon,
        separator,
        spacer, memwidget, spacer, mmwidget, memicon,
        separator,
        cpuwidget, spacer, cuwidget, thermalwidget, cpuicon,
		separator,
		mpdwidget, mpdicon,
		separator,
		tasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = awful.util.spawn(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client mouse bindings
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}


-- {{{ Key bindings
--
-- {{{ Global keys
globalkeys = awful.util.table.join(
    -- {{{ Applications
    awful.key({ modkey }, "Return", function () awful.util.spawn("xterm", false) end),
	awful.key({ modkey }, "r", function () awful.util.spawn("dmenu_run -fn \"-*-terminus-medium-r-normal-*-12-*-*-*-*-*-*-*\" -nb \"#daff30\" -nf \"#888888\" -sb \"#2A2A2A\" -sf \"#daff30\"", false) end),
    awful.key({ modkey, "Shift" }, "w", function () awful.util.spawn("thunar", false) end),
    awful.key({ modkey, "Shift" }, "f", function () awful.util.spawn("firefox", false) end),
    awful.key({ altkey }, "F1",  function () awful.util.spawn("urxvt", false) end),
    awful.key({ modkey }, "F2",  function () teardrop.toggle("gmrun", 1, 0.08) end),
    awful.key({ modkey, "Shift" }, "Down", function () awful.util.spawn("amixer -q sset Master 2dB-", false) end),
	awful.key({ modkey, "Shift" }, "Up", function () awful.util.spawn("amixer -q sset Master 2dB+", false) end),
	awful.key({ modkey, "Shift" }, "Right", function () awful.util.spawn("mpc next", false) end),
	awful.key({ modkey, "Shift" }, "Left", function () awful.util.spawn("mpc stop", false) end),
	-- }}}

    -- {{{ Multimedia keys
    awful.key({}, "Print",function () awful.util.spawn("scrot -d 3 'shot-%Y%m%d-%H.%M.%S.png'", false) end),
    -- }}}

    -- {{{ Prompt menus
    --     - Run, Dictionary, Manual, Lua, SSH, Calculator and Web search
    awful.key({ altkey }, "F2", function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = awful.util.spawn(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),
    awful.key({ altkey }, "F3", function ()
        awful.prompt.run({ prompt = "Dictionary: " }, promptbox[mouse.screen].widget,
            function (words)
                local xmessage = "xmessage -timeout 10 -file -"
                awful.util.spawn_with_shell("crodict " .. words .. " | " .. xmessage, false)
            end)
    end),
    awful.key({ altkey }, "F4", function ()
        awful.prompt.run({ prompt = "Manual: " }, promptbox[mouse.screen].widget,
            function (page) awful.util.spawn("urxvt -e man " .. page, false) end)
    end),
    awful.key({ altkey }, "F5", function ()
        awful.prompt.run({ prompt = "Run Lua code: " }, promptbox[mouse.screen].widget,
        awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval")
    end),
    awful.key({ altkey }, "F10", function ()
        awful.prompt.run({ prompt = "Connect: " }, promptbox[mouse.screen].widget,
            function (host) awful.util.spawn("urxvt -e ssh " .. host, false) end)
    end),
    awful.key({ altkey }, "F11", function ()
        awful.prompt.run({ prompt = "Calculate: " }, promptbox[mouse.screen].widget,
            function (expr)
                local xmessage = "xmessage -timeout 10 -file -"
                awful.util.spawn_with_shell("echo '" .. expr .. ' = ' ..
                  awful.util.eval("return (" .. expr .. ")") .. "' | " .. xmessage, false)
            end)
    end),
    awful.key({ altkey }, "F12", function ()
        awful.prompt.run({ prompt = "Web search: " }, promptbox[mouse.screen].widget,
            function (command)
                awful.util.spawn("firefox 'http://yubnub.org/parser/parse?command="..command.."'", false)
                if tags[mouse.screen][3] then awful.tag.viewonly(tags[mouse.screen][3]) end
            end)
    end),
    -- }}}

    -- {{{ Awesome controls
    awful.key({ modkey, "Shift" }, "BackSpace", awesome.quit),
    awful.key({ modkey, "Shift" }, "r", function ()
        promptbox[mouse.screen].text = awful.util.escape(awful.util.restart())
    end),
    -- }}}

    -- {{{ Tag browsing
	awful.key({ altkey }, "Tab",    awful.tag.viewnext),
    awful.key({ altkey }, "n",      awful.tag.viewnext),
    awful.key({ altkey }, "p",      awful.tag.viewprev),
    awful.key({ altkey }, "Escape", awful.tag.history.restore),
    -- }}}

    -- {{{ Layout manipulation
    awful.key({ modkey }, "l",          function () awful.tag.incmwfact(0.05) end),
    awful.key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.incwfact(0.05) end),
    awful.key({ modkey }, "space",          function () awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ altkey, "Shift" }, "l",     function () awful.tag.incnmaster(-1) end),
    awful.key({ altkey, "Shift" }, "h",     function () awful.tag.incnmaster(1) end),
    awful.key({ modkey, "Control" }, "l",   function () awful.tag.incncol(-1) end),
    awful.key({ modkey, "Control" }, "h",   function () awful.tag.incncol(1) end),
    -- }}}

    -- {{{ Focus controls
    awful.key({ modkey }, "p", function () awful.screen.focus_relative(1) end),
    awful.key({ modkey }, "s", function ()
        for k, c in pairs(client.get(mouse.screen)) do
            if c.minimized then -- Scratchpad replacement/imitation
                awful.client.movetotag(awful.tag.selected(mouse.screen), c)
                awful.client.floating.set(c, true)
                awful.placement.centered(c)
                c.minimized = false; c.sticky = true
                client.focus = c; c:raise()
            end
        end
    end),
    awful.key({ modkey }, "Tab", function () awful.client.focus.byidx(1);
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "j",   function () awful.client.focus.byidx(1);
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k",   function () awful.client.focus.byidx(-1);
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "#48", function () awful.client.focus.bydirection("down");
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "#34", function () awful.client.focus.bydirection("up");
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "#47", function () awful.client.focus.bydirection("left");
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "#51", function () awful.client.focus.bydirection("right");
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey, "Shift" }, "j",   function () awful.client.swap.byidx(1) end),
    awful.key({ modkey, "Shift" }, "k",   function () awful.client.swap.byidx(-1) end),
    awful.key({ modkey, "Shift" }, "#48", function () awful.client.swap.bydirection("down") end),
    awful.key({ modkey, "Shift" }, "#34", function () awful.client.swap.bydirection("up") end),
    awful.key({ modkey, "Shift" }, "#47", function () awful.client.swap.bydirection("left") end),
    awful.key({ modkey, "Shift" }, "#51", function () awful.client.swap.bydirection("right") end)
    -- }}}
)
-- }}}

-- {{{ Client manipulation
clientkeys = awful.util.table.join(
    awful.key({ modkey }, "b", function () -- Hide the wibox
        if wibox[mouse.screen].screen == nil then wibox[mouse.screen].screen = mouse.screen
        else wibox[mouse.screen].screen = nil end
    end),
    awful.key({ modkey, "Shift" }, "q", function (c) c:kill() end),
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey }, "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ modkey }, "o",     awful.client.movetoscreen),
    awful.key({ modkey }, "Next",  function () awful.client.moveresize(20, 20, -20, -20) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20, 20, 20) end),
    awful.key({ modkey }, "Down",  function () awful.client.moveresize(0, 20, 0, 0) end),
    awful.key({ modkey }, "Up",    function () awful.client.moveresize(0, -20, 0, 0) end),
    awful.key({ modkey }, "Left",  function () awful.client.moveresize(-20, 0, 0, 0) end),
    awful.key({ modkey }, "Right", function () awful.client.moveresize(20, 0, 0, 0) end),
    awful.key({ modkey },          "d", function (c) c.minimized = not c.minimized end),
    awful.key({ modkey, "Shift" }, "0", function (c) c.sticky = not c.sticky end),
    awful.key({ modkey, "Shift" }, "o", function (c) c.ontop = not c.ontop end),
    awful.key({ modkey, "Shift" }, "t", function (c)
        if c.titlebar then awful.titlebar.remove(c) 
        else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey, "Control" }, "r",      function (c) c:redraw() end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    -- Suspend/resume on focus changes could be auto. when running on bat power, if only suspending FF:
    awful.key({ modkey, "Shift" }, "c", function (c) awful.util.spawn("kill -CONT "..c.pid, false) end),
    awful.key({ modkey, "Shift" }, "s", function (c) awful.util.spawn("kill -STOP "..c.pid, false) end)
)
-- }}}

-- {{{ Bind keyboard digits
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
-- }}}

-- {{{ Tag controls
for i = 1, keynumber do
    globalkeys = awful.util.table.join( globalkeys,
        awful.key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end),
        awful.key({ modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewtoggle(tags[screen][i])
                end
            end),
        awful.key({ modkey, "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.movetotag(tags[client.focus.screen][i])
                end
            end),
        awful.key({ modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.toggletag(tags[client.focus.screen][i])
                end
            end))
end
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = true,
          keys = clientkeys,
          buttons = clientbuttons
    }},
    -- Application specific behaviour
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Qq" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Akregator" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Sonata" },
      properties = { tag = tags[1][9] } },
    { rule = { name = "Alsamixer" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Gimp" },
      properties = { tag = tags[1][9] } },
    { rule = { name = "Mutt" },
      properties = { tag = tags[1][4] } },
    { rule = { instance = "uTorrent.exe" },
      properties = { tag = tags[screen.count()][9] } },
    { rule = { class = "Gvim" },
      properties = { tag = tags[screen.count()][3] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[screen.count()][2] } },
    { rule = { class = "Firefox", instance = "Download" },
      properties = { floating = true } },
    { rule = { class = "Firefox", instance = "Places" },
      properties = { floating = true } },
    { rule = { class = "Firefox", instance = "Greasemonkey" },
      properties = { floating = true } },
    { rule = { class = "Firefox", instance = "Extension" },
      properties = { floating = true } },
    { rule = { class = "Firefox", instance = "Scrapbook" },
      properties = { floating = true } },
    { rule = { class = "Emacs", instance = "_Remember_" },
      properties = { floating = true } },
    { rule = { class = "Xmag", instance = "xmag" },
      properties = { floating = true } },
    { rule = { class = "Xmessage", instance = "xmessage" },
      properties = { floating = true } },
    { rule = { class = "ROX%-Filer" },
      properties = { floating = true } },
    { rule = { class = "Ark" },
      properties = { floating = true } },
    { rule = { class = "Kgpg" },
      properties = { floating = true } },
    { rule = { class = "Kmix" },
      properties = { floating = true } },
    { rule = { class = "Geeqie" },
      properties = { floating = true } },
    { rule = { class = "Smplayer" },
      properties = { floating = true } },
    { rule = { class = "xine" },
      properties = { floating = true } },
    { rule = { class = "Whar" },
      properties = { floating = true } },
    { rule = { name = "VLC player" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Autorun programs
autorun = "true"
autorunApps =
{
	 "xsetroot -cursor_name left_ptr",
	 "fcitx",
	-- "parcellite",
}
if autorun then
	for app = 1, #autorunApps do
		awful.util.spawn(autorunApps[app])
	end
end
-- }}}

-- {{{ Signals
--
-- {{{ Signal function to execute when a new client appears
client.add_signal("manage", function (c, startup)
    -- Add a titlebar to each client if enabled globaly
    if use_titlebar then
        awful.titlebar.add(c, { modkey = modkey })
    -- Floating clients always have titlebars
    elseif awful.client.floating.get(c)
        or awful.layout.get(c.screen) == awful.layout.suit.floating then
            if not c.titlebar and c.class ~= "Xmessage" then
                awful.titlebar.add(c, { modkey = modkey })
            end
            -- Floating clients are always on top
            c.above = true
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Set new clients as slaves
    awful.client.setslave(c)

    -- New floating windows:
    --   - don't cover the wibox
    awful.placement.no_offscreen(c)
    --   - don't overlap until it's unavoidable
    --awful.placement.no_overlap(c)
    --   - are centered on the screen
    --awful.placement.centered(c, c.transient_for)

    -- Honoring of size hints
    --   - false will remove gaps between windows
    c.size_hints_honor = false
end)
-- }}}

-- {{{ Focus signal functions
client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- }}}
