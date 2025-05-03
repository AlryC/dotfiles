-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

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
local hotkeys_popup = require("awful.hotkeys_popup")
local home_path = os.getenv("HOME") .. "/"
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

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

--- {{{ Helpers
-- Read from a file
local function read_file(path)
    local f = io.open(path, "r")
    if f then
        local content = f:read("*all")
        f:close()
        return content
    end
    return nil
end

local function not_mono(str) return '<span font_family="FiraCode Nerd Font">'..str..'</span>' end
--- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init( home_path .. ".config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "alacritty"
local editor = "nvim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
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

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

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
    awful.tag({ "", "", "", "", "", "󰑌" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout  = {
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                        align  = 'center',
                    },
                    widget = wibox.container.place, -- centers text horizontally
                },
                forced_width = 50,                 -- ✅ THIS sets tag width
                widget = wibox.container.background,
                id = 'background_role',
                shape = gears.shape.rounded_bar,   -- optional: pill style
            },
            widget  = wibox.container.margin,
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        widget_template = {
            {
                {
                    id = 'text_role',
                    widget = wibox.widget.textbox,
                    align = 'center',
                },
                layout = wibox.layout.flex.horizontal,
            },
            id = "background_role",
            widget = wibox.container.background,
        }
    }

    -- <<<<<<<<<<<<<<<<<<<<<<< Custom widgets >>>>>>>>>>>>>>>>>>>>>>> --

    -- << Left >> --
    -- Create a textbox widget which will contain an icon indicating which layout we're using.
    s.mylayouttext = wibox.widget {
        widget = wibox.widget.textbox,
        markup = not_mono("   "),
    }
    s.mylayouttext:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end)
                           --awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           --awful.button({ }, 5, function () awful.layout.inc(-1) end),
    ))

    -- << Right >> --
    -- Create a battery widget
    s.mybattery = wibox.widget {
        widget = wibox.widget.textbox,
        text = " ? ",
        hidden = false,
    }
    -- Battery icons for different levels
    local BATTERY_ICONS = { " ", " ", " ", " ", " " }
    local BATT_PATH = "/sys/class/power_supply/BAT0"
    -- Update function
    local function update_battery()
        local status = read_file(BATT_PATH .. "/status") or ""
        local capacity = tonumber(read_file(BATT_PATH .. "/capacity")) or 0

        local icon = ""
        if status ~= "Charging\n" and status ~= "Full\n" then
            icon = BATTERY_ICONS[math.min(math.floor(capacity / 20) + 1, 5)]
        end

        if s.mybattery.hidden then
           s.mybattery.markup = string.format(' %s ', not_mono(icon))
        else
           s.mybattery.markup = string.format(' %s %d%% ', not_mono(icon), capacity)
        end
    end
    -- Make it clickable
    s.mybattery:buttons(gears.table.join( -- add turning pc off and on rofi widget on left click
        --awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () s.mybattery.hidden = not s.mybattery.hidden update_battery() end)
    ))
    -- Timer to refresh battery info every 5s
    gears.timer {
        timeout = 5,
        autostart = true,
        call_now = true,
        callback = update_battery
    }

    -- Create a wifi widget
    s.mywifi = wibox.widget {
        widget = wibox.widget.textbox,
        text = " ? ",
        hidden = false,
    }
    -- Update function
    local function update_wifi()
        local pipe = io.popen("wpa_cli -i wlo1 status")
        if not pipe then return nil end
        local output = pipe:read("*a")
        pipe:close()
        local ssid = "Disconnected"
        for line in output:gmatch("[^\r\n]+") do
            local key, value = line:match("^(.-)=(.*)$")
            if key == "ssid" then
                ssid = value
            end
        end
        local icon = ''
        if s.mywifi.hidden then
            s.mywifi.markup = string.format(' %s  ', not_mono(icon))
        else
            s.mywifi.markup = string.format(' %s  %s ', not_mono(icon), ssid)
        end
    end
    -- Make it clickable
    s.mywifi:buttons(gears.table.join( -- add wifi select rofi widget on left click
        --awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () s.mywifi.hidden = not s.mywifi.hidden update_wifi() end)
    ))
    -- Timer to refresh
    gears.timer {
        timeout = 5,
        autostart = true,
        call_now = true,
        callback = update_wifi,
    }

    -- Create a bluetooth widget
    s.mybluetooth = wibox.widget {
        widget = wibox.widget.textbox,
        text = " ? ",
        hidden = false,
    }
    -- Update function
    local function update_bluetooth()
        local icon = "󰂯" --󰂲󰂱󰂰
        local device = ""

        -- Try to read paired + connected devices using bluetoothctl
        local handler = io.popen("bluetoothctl info 2>/dev/null")
        local output = handler and handler:read("*a") or ""
        if handler then handler:close() end

        if output:match("Connected: yes") then
            icon = "󰂱"  -- Connected icon
            device = output:match("Name: ([^\n]+)") or "Connected"
        elseif output:match("Powered: yes") then
            icon = "󰂯"  -- On but not connected
            device = "On"
        else
            icon = "󰂲"  -- Powered off
            device = "Off"
        end

        if s.mybluetooth.hidden then
           s.mybluetooth.markup = string.format(' %s ', not_mono(icon))
        else
           s.mybluetooth.markup = string.format(' %s %s ', not_mono(icon), device)
        end
    end
    -- Make it clickable
    s.mybluetooth:buttons(gears.table.join( -- add bluetooth rofi widget on left click
        --awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () s.mybluetooth.hidden = not s.mybluetooth.hidden update_bluetooth() end)
    ))
    -- Timer to refresh battery info every 5s
    gears.timer {
        timeout = 5,
        autostart = true,
        call_now = true,
        callback = update_bluetooth,
    }


    -- Create a ram widget

    -- Create a cpu widget

    -- Keyboard map indicator and switcher
    s.mykeyboardlayout = awful.widget.keyboardlayout()
 --   s.mykeyboardlayout:connect_signal("widget::redraw_needed", function(widget)
 --       widget.text = ' <span font_family="FiraCode Nerd Font">⌨</span> ' .. widget.text:upper()
 --   end)

    -- Create a textclock widget
    s.mytextclock = wibox.widget.textclock(' ' .. not_mono('') .. ' %H:%M ')

    -- Create a systray widget
    s.mysystray = wibox.widget.systray()
    s.mysystray.opacity = 0

    ToggleWidgets = function()
        -- Toggle first widget
        s.mywifi.hidden =  not s.mywifi.hidden
        -- Set all other widgets to the state of the first
        s.mybluetooth.hidden = s.mywifi.hidden
        s.mybattery.hidden = s.mywifi.hidden
        update_wifi()
        update_bluetooth()
        update_battery()
    end

    -- -------------------------------------------------------------- --

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = 26,
        type = "dock",
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mylayouttext,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mykeyboardlayout,
            wibox.widget.textbox(""),
	        s.mywifi,
            wibox.widget.textbox(""),
	        s.mybluetooth,
            wibox.widget.textbox(""),
            s.mybattery,
            wibox.widget.textbox(""),
            s.mytextclock,
            s.mysystray,
        },
    }
    -- Custom layout names
    local function update_layouttext(t)
        local layout = awful.layout.getname(t.layout)
        local layout_names = {
            floating = not_mono("   "),
            tile     = not_mono("   "),
            fairv    = not_mono("   "),
        }
        local text = layout_names[layout] or layout
        if t.screen and t.screen.mylayouttext then
            t.screen.mylayouttext.markup = text
        end
    end

    tag.connect_signal("property::layout", update_layouttext)
    tag.connect_signal("property::selected", update_layouttext)
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({                   }, "F4",     awful.tag.history.restore,
              {description = "switch to last tag (not window)", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
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
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function () menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Custom
    -- Toggle Modes
    awful.key({ modkey }, "f", function () awful.screen.focused().selected_tag.layout = awful.layout.suit.floating end,
              {description = "set floating layout for tag", group = "client"}),
    awful.key({ modkey }, "t", function () awful.screen.focused().selected_tag.layout = awful.layout.suit.tile end,
              {description = "set tiling layout for tag", group = "client"}),

    -- (Un)hide status bar widgets
    awful.key({ modkey }, "h", function () ToggleWidgets() end,
              {description = "set tiling layout for tag", group = "client"}),

    -- Select Wallpaper
    awful.key({ modkey, "Shift" }, "w", function () os.execute("~/suckless/assets/scripts/dt-wallpaper-select.sh") end,
              {description = "set tiling layout for tag", group = "client"}),
    -- Take a screenshot
    awful.key({ }, "Print", function() os.execute("maim --select | xclip -selection clipboard -t image/png") end,
              {description = "make a screenshot", group = "launcher"})
)

-- CLIENT KEY SHORTCUTS
clientkeys = gears.table.join(
    awful.key({ modkey,           }, "g",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({                   }, "F1",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey,           }, "F1",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ "Shift"           }, "F1",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
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

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     callback = awful.client.setslave
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Prevent clients from being unreachable after screen count changes
    if awesome.startup and
       not c.size_hints.user_position and
       not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
    -- Only center *non-maximized* floating clients, and only if not at startup
    if not awesome.startup and
       (c.floating or awful.layout.get(c.screen) == awful.layout.suit.floating) and
       not c.maximized and
       not c.fullscreen and
       not c.size_hints.user_position and
       not c.size_hints.program_position then
        awful.placement.centered(c, nil)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
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
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- If window is maximized then remove the border
-- Don't forget to restore the border color
client.connect_signal("property::maximized", function(c)
    if c.maximized then c.border_width = 0
    else c.border_width = beautiful.border_width end
end)

client.connect_signal("focus", function(c)
    if c.maximized then
        c.border_width = 0
    else
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end)

client.connect_signal("unfocus", function(c)
    if not c.maximized then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_normal
    end
end)

-- }}}
