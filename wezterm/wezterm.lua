local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Spawn a fish shell in login mode
config.default_prog = { "/usr/bin/fish" }

-- QOL

local function basename(s)
	if not s then
		return ""
	end
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local my_icons = {
	nvim = wezterm.nerdfonts.linux_neovim,
	fish = wezterm.nerdfonts.dev_terminal,
	ssh = wezterm.nerdfonts.md_ssh,
	lazygit = wezterm.nerdfonts.fa_git,
	htop = wezterm.nerdfonts.md_view_dashboard,
}

local function format_process_name(s)
	local name = basename(s)
	if my_icons[name] then
		return my_icons[name]
	end
	return name
end

--Base
config.color_scheme = "Arthur"
config.font = wezterm.font("JetBrainsMono NF")

config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"

config.scrollback_lines = 3500
config.default_workspace = "home"

--Style

config.window_background_opacity = 1.0

config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.0,
}

config.use_fancy_tab_bar = false
config.status_update_interval = 500
-- Status bar
wezterm.on("update-right-status", function(window, pane)
	local stat = format_process_name(pane:get_foreground_process_name())
	if window:leader_is_active() then
		stat = wezterm.nerdfonts.md_apple_keyboard_command .. " LEADER"
	end
	if window:active_key_table() then
		stat = wezterm.nerdfonts.md_view_dashboard .. " " .. window:active_key_table()
	end
	window:set_right_status(wezterm.format({
		{ Text = " " .. stat .. " " },
		{ Text = " | " },
	}))
end)

-- Tab title
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = format_process_name(tab.active_pane:get_foreground_process_name())

	return title
end)

-- Keys
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "f", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		win:maximize()
	end) },
	{ key = "F", mods = "LEADER", action = wezterm.action_callback(function(win, pane)
		win:restore()
	end) },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

	{
		key = "t",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			local overrides = win:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.1
			else
				overrides.window_background_opacity = 1.0
			end
			win:set_config_overrides(overrides)
		end),
	},

	-- Panes
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

	-- Tabs
	{ key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "H", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "J", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "K", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "L", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "LeftArrow", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "DownArrow", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "UpArrow", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "RightArrow", mods = "LEADER", action = act.ActivateTabRelative(1) },
}

-- Set Active Tab
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- Key Tables
--
config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}
-- END
return config
