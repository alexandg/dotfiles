-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Scratch for dropdown
local scratch = require("scratch")
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
        text = err })
        in_error = false
    end)
end
-- }}}

--- {{{ Notification settings
naughty.config.defaults.position = "top_right"
naughty.config.defaults.border_width = 1
--- }}}

--- {{{ Custom vertical tasklist and taglist
-- based on https://github.com/Ahrotahn/dotawesome/blob/master/rc.lua
function vertical_tasklist(w, buttons, label, data, objects)
    w:reset()
    for o = #objects, 1, -1 do
        local cache = data[objects[o]]
        local ib, bgb, m, l
        if cache then
            ib = cache.ib
            bgb = cache.bgb
            m = cache.m
        else
            ib = wibox.widget.imagebox()
            m = wibox.layout.margin(ib, 3, 3, 6, 6)
            l = wibox.layout.fixed.vertical()
            l:fill_space(true)
            l:add(m)
            bgb = wibox.layout.margin(l, 0, 2, 0, 0)
            bgb:buttons(common.create_buttons(buttons, objects[o]))
            data[objects[o]] = {
                ib = ib,
                bgb = bgb,
                m = m
            }
        end
        local text, bg, bg_image, icon = label(objects[o])
        bgb:set_color(bg)
        if icon then
            ib:set_image(icon)
        else
            ib:set_image(beautiful.generic_icon)
        end
        w:add(bgb)
    end
end

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
            bgb = wibox.widget.background()
            bgt = wibox.widget.background()
            ah = wibox.layout.align.horizontal()
            ah:set_middle(tb)
            bgt:set_widget(ah)
            ms = wibox.layout.margin(bgt, 0, 2, 0, 0)
            m = wibox.layout.margin(ms, 0, 0, 0, 2)
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
        --tb:set_markup(markup(beautiful.text_light, text))
        --if not pcall(tb.set_markup, tb, markup(beautiful.text_dark, text)) then
            --tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        --end
        --if bg_image == "light" then
            --tb:set_markup(markup(beautiful.text_light, text))
        --end
        tb:set_markup(text)
        bgt:set_bg(bg)
        if bg == beautiful.taglist_bg_focus then
            ms:set_color(beautiful.fg_focus)
        else
            ms:set_color(beautiful.border_normal)
        end
        w:add(bgb)
   end
end
--- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal --command='tmux -2'"
editor = os.getenv("EDITOR") or "vim"
home_dir = os.getenv("HOME") or ""
editor_cmd = terminal .. " -e " .. editor

-- Start Xcompmgr
awful.util.spawn_with_shell("xcompmgr &")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(home_dir .. "/.config/awesome/themes/zen-nokto/theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
    awful.layout.suit.floating
}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, "chat", "music", "email" }, s, layouts[1])
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, "C", "M", "E" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
}

mymainmenu = awful.menu({ items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    { "Debian", debian.menu.Debian_menu.Debian },
    { "open terminal", terminal },
    { "Lock Screen", function () awful.util.spawn("xscreensaver-command -lock") end },
    { "Suspend", "systemctl suspend" },
    { "Sleep", "systemctl hybrid-sleep" },
    { "Hibernate", "systemctl hibernate" },
    { "Reboot", "systemctl reboot" },
    { "Shutdown", "systemctl poweroff" },
}})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

-- Systray
systray = wibox.widget.systray()
systray:set_horizontal(false)

-- Create a wibox for each screen and add it
mywibox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() then
                awful.tag.viewonly(c:tags()[1])
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function ()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({
                theme = { width = 250 }
            })
        end
    end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end)
)

for s = 1, screen.count() do
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = wibox.layout.margin(awful.widget.layoutbox(s), 4, 4, 4, 4)
    mylayoutbox[s]:set_color(beautiful.color_light)
    mylayoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons, nil, vertical_taglist, wibox.layout.fixed.vertical())

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons, nil, vertical_tasklist, wibox.layout.fixed.vertical())

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "left", screen = s, width = 24 })

    -- Widgets that are aligned to the top
    local left_layout = wibox.layout.fixed.vertical()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mytasklist[s])

    -- Widgets that are aligned to the bottom
    local right_layout = wibox.layout.fixed.vertical()
    right_layout:add(systray)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together
    local layout = wibox.layout.align.vertical()
    layout:set_top(left_layout)
    layout:set_bottom(right_layout)

    mywibox[s]:set_widget(layout)
end
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
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    -- Volume Control
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q set Master 5%+ unmute") end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q set Master 5%- unmute") end),
    -- Terminal Dropdown
    awful.key({ modkey }, "F1", function () awful.util.spawn("xfce4-terminal --drop-down -e " .. home_dir .. "/bin/tmux_dropdown.sh") end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Menubar
    awful.key({ modkey }, "z", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      function(c) awful.client.movetoscreen(c, c.screen-1) end),
    awful.key({ modkey,           }, "p",      function(c) awful.client.movetoscreen(c, c.screen+1) end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = clientkeys,
          buttons = clientbuttons
        }
    },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Youtube video fullscreen Firefox
    { rule = { instance = "plugin-containter" },
      properties = { floating = true } },
    -- youtube fullscreen chromium
    { rule = { instance = "exe" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Icedove" },
      properties = { tag = tags[1][9] } },
    { rule = { class = "Pithos" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Exaile" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Quodlibet" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Clementine" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][7] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ AutoStart
function run_once(prg, arg_string, pname, screen)
	if not prg then
		do return nil end
	end

	if not pname then
		pname = prg
	end

	if not arg_string then
		awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")", screen)
	else
		awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")", screen)
	end
end

run_once("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
run_once("start-pulseaudio-x11")
run_once("xfce4-power-manager")
run_once("xscreensaver", "-no-splash")
run_once("nm-applet")
run_once("thunar", "--daemon")
run_once(home_dir .. "/bin/conky_start.sh")
run_once("kupfer", "--no-splash")
run_once("icedove")
run_once("xmodmap", home_dir .. "/.xmodmaprc")
run_once(home_dir .. "/bin/tmux_sessions.sh")
run_once(home_dir .. "/bin/update_vim_plugins.sh")
run_once(home_dir .. "/bin/volumeicon.sh")
run_once("xbacklight", "-set 20");
-- }}}
