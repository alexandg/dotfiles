-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local common = require("awful.widget.common")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
home_dir = os.getenv("HOME") or ""
theme = ""
if home_dir == "" then
    theme = awful.util.get_themes_dir() .. "zenburn/theme.lua"
else
    theme = home_dir .. "/.config/awesome/themes/apprentice/theme.lua"
end
beautiful.init(theme)

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal --command='tmux -2'"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "Hotkeys", function() return false, hotkeys_popup.show_help end},
    { "Manual", terminal .. " -e man awesome" },
    { "Edit config", editor_cmd .. " " .. awesome.conffile },
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = {
    { "Awesome", myawesomemenu, beautiful.awesome_icon },
    { "Debian", debian.menu.Debian_menu.Debian },
    { "Open Terminal", terminal },
    { "Lock Screen", function () awful.spawn("xscreensaver-command -lock") end },
    { "Suspend", "systemctl suspend" },
    { "Reboot", "systemctl reboot" },
    { "Shutdown", "systemctl poweroff" }
}})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal
-- }}}

-- {{{ Wibar
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Systray
systray = wibox.widget.systray()
systray:set_horizontal(false)

-- Create a textclock widget
--mytextclock = wibox.widget.textclock()

-- Create 2 widgets to act as the horizontal clock
clock_hours = wibox.widget.textclock("%H")
clock_hours:set_align("center")
clock_hours_widget = wibox.container.margin(clock_hours, 2, 2, 2, 2)
clock_hours_widget:set_color(beautiful.color_dark)

clock_minutes = wibox.widget.textclock("%M")
clock_minutes:set_align("center")
clock_minutes_widget = wibox.container.margin(clock_minutes, 2, 2, 2, 2)
clock_minutes_widget:set_color(beautiful.color_dark)

--- {{{ Vertical Tasklist
function vertical_tasklist(w, buttons, label, data, objects)
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, tbm, ibm, l
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            ibm = cache.ibm
        else
            ib = wibox.widget.imagebox()
            tb = wibox.widget.textbox()
            bgb = wibox.container.background()
            ibm = wibox.container.margin(ib, 2, 2, 2, 2)
            l = wibox.layout.fixed.vertical()

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ibm)

            -- And all of this gets a background
            bgb:set_widget(l)

            bgb:buttons(common.create_buttons(buttons, o))

            data[o] = {
                ib  = ib,
                tb  = tb,
                bgb = bgb,
                ibm = ibm,
            }
        end

        local text, bg, bg_image, icon, args = label(o, tb)
        args = args or {}

        bgb:set_bg(bg)
        if type(bg_image) == "function" then
            bg_image = bg_image(tb,o,nil,objects,i)
        end
        bgb:set_bgimage(bg_image)
        if icon then
            ib:set_image(icon)
        else
            ib:set_image(beautiful.awesome_icon)
        end

        bgb.shape              = args.shape
        bgb.shape_border_width = args.shape_border_width
        bgb.shape_border_color = args.shape_border_color

        w:add(bgb)
   end
end
--- }}}

--- {{{ Vertical Taglist
-- from https://github.com/Ahrotahn/dotawesome/blob/master/rc.lua
function vertical_taglist(w, buttons, label, data, objects)
    w:reset()
    for i, o in ipairs(objects) do
        local cache = data[o]
        local tb, bgb, m, ah, bgt, ms
        if cache then
            tb = cache.tb
            bgb = cache.bgb
            m = cache.m
            ah = cache.ah
            bgt = cache.bgt
            ms = cache.ms
        else
            tb = wibox.widget.textbox()
            bgb = wibox.container.background()
            bgt = wibox.container.background()
            ah = wibox.layout.align.horizontal()
            ah:set_middle(tb)
            bgt:set_widget(ah)
            ms = wibox.container.margin(bgt, 2, 0, 0, 0)
            m = wibox.container.margin(ms, 0, 0, 2, 2)
            bgb:set_bg(beautiful.border_normal)
            bgb:set_widget(m)
            bgb:buttons(common.create_buttons(buttons, o))
            data[o] = {
                tb = tb,
                bgb = bgb,
                m   = m,
                ah = ah,
                bgt = bgt,
                ms = ms
            }
        end
        local text, bg, bg_image, icon = label(o)
        local num_clients = 0
        for k, v in pairs(o:clients()) do
            num_clients = num_clients + 1
        end
        tb:set_markup(text)
        tb:set_align("center")
        bgt:set_bg(bg)
        if num_clients == 0 then
            ms:set_color(beautiful.fg_focus)
        else
            ms:set_color(beautiful.border_focus)
        end
        w:add(bgb)
   end
end
--- }}}

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, client_menu_toggle_fn()),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "C", "M", "E" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    --s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {}, vertical_taglist, wibox.layout.fixed.vertical())

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, {}, vertical_tasklist, wibox.layout.fixed.vertical())

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "left", screen = s, width = 24 })

    -- Add widgets to the wibox
    s.mywibox : setup {
        layout = wibox.layout.align.vertical,
        -- Top Widgets
        {
            layout = wibox.layout.fixed.vertical,
            mylauncher,
            s.mytaglist,
        },
        s.mytasklist,
        -- Bottom Widgets
        {
            layout = wibox.layout.fixed.vertical,
            systray,
            s.mylayoutbox,
            clock_hours_widget,
            clock_minutes_widget,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s", hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left", awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right", awful.tag.viewnext,
    {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx(1) end,
    {description = "focus next by index", group = "client"} ),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
    {description = "focus previous by index", group = "client"} ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end,
    {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end,
    {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end,
    {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l", function () awful.tag.incmwfact( 0.05) end,
    {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h", function () awful.tag.incmwfact(-0.05) end,
    {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol(1, nil, true) end,
    {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true) end,
    {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) end,
    {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end,
    {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n", function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            client.focus = c
            c:raise()
        end
    end,
    {description = "restore minimized", group = "client"}),

    -- Prompt
    --awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    --{description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",function ()
        awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
    end,
    {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end,
    --{description = "show the menubar", group = "launcher"}),

    -- Custom global keys
    awful.key({ modkey }, "F1", function()
        awful.util.spawn("xfce4-terminal --drop-down -e " ..
                         home_dir ..
                         "/bin/tmux_dropdown.sh")
    end,
    {description = "", group = "awesome"}),
    awful.key({ }, "XF86AudioRaiseVolume", function ()
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    end,
    {description = "Raise Volume", group = "awesome"}),
    awful.key({ }, "XF86AudioLowerVolume", function()
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    end,
    {description = "Lower Volume", group = "awesome"})
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f", function (c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end,
    {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
    {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
    --awful.key({ modkey,           }, "o", function (c) c:move_to_screen() end,
    --{description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t", function (c) c.ontop = not c.ontop end,
    {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n", function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end ,
    {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m", function (c)
        c.maximized = not c.maximized
        c:raise()
    end,
    {description = "maximize", group = "client"}),

    -- Custom client keys
    awful.key({ modkey,           }, "o", function (c) c:move_to_screen(c.screen.index - 1) end,
    {description = "move to previous screen", group = "client"}),
    awful.key({ modkey,           }, "p", function (c) c:move_to_screen(c.screen.index + 1) end,
    {description = "move to next screen", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end,
    {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end,
    {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end,
    {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
                client.focus:toggle_tag(tag)
            end
        end
    end,
    {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                --"pinentry",
                "veromix",
                "xtightvncviewer",
                -- More floating windows
                "plugin-containter",
                "exe",
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },
    {
        rule_any = {
            type = { "dialog" },
            class = { "pinentry", "gcr-prompter" },
            name = { "pinentry-gnome3" }
        },
        properties = { titlebars_enabled = true }
    },
    -- Custom Program Tag rules
    { rule = { class = "conky", "Conky" }, properties = { screen = 1 } },
    { rule = { class = "Icedove" }, properties = { screen = 1, tag = "E" } },
    { rule = { class = "Thunderbird" }, properties = { screen = 1, tag = "E" } },
    { rule = { class = "Pithos" }, properties = { screen = 1, tag = "M" } },
    { rule = { class = "Quodlibet" }, properties = { screen = 1, tag = "M" } },
    { rule = { class = "Kupfer" }, properties = { border_width = 0 } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
        not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
    awful.button({ }, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
    end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Notification settings
naughty.config.defaults.position = "bottom_right"
naughty.config.defaults.border_width = 1

-- Display Notifications on all screen when using multiple monitors
naughty.notify_original = naughty.notify
naughty.notify = function (args,...)
    notifications = {}
    for idx = 1, screen.count() do
        args.screen = idx
        table.insert(notifications, idx, naughty.notify_original(args,...))
    end
    return notifications
end
--- }}}

--- {{{ Autostart run_once
function run_once(prg, args, pname, screen)
    if not prg then
        do return nil end
    end

    if not pname then
        pname = prg
    end

    if not args then
		awful.spawn.with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")", screen)
	else
		awful.spawn.with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. args .. ")", screen)
    end
end

run_once("xcompmgr")
run_once("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
run_once("start-pulseaudio-x11")
run_once("xfce4-power-manager")
run_once("xscreensaver", "-no-splash")
run_once("nm-applet")
run_once("thunar", "--daemon")
run_once("kupfer", "--no-splash")
run_once("thunderbird")
run_once("pasystray")
awful.spawn.with_shell("xbacklight -set 20");
awful.spawn.with_shell(home_dir .. "/bin/update_vim_plugins.sh")
awful.spawn("conky -c " .. home_dir .. "/.conkyrc.lua")
awful.spawn("conky -c " .. home_dir .. "/.conkyrc2.lua")
awful.spawn.with_shell(home_dir .. "/bin/tmux_sessions.sh")
awful.spawn.with_shell("xmodmap " .. home_dir .. "/.xmodmaprc")
---- }}}
