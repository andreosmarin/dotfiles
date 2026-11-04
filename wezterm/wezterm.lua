local wezterm = require("wezterm")
local constants = require("constants")
local commands = require("commands")
local config = wezterm.config_builder()

-- ==============================================================================
-- 1. FONT
-- ==============================================================================
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 15
config.line_height = 1.2

-- ==============================================================================
-- 2. COLORS & THEME
-- ==============================================================================
config.colors = require("cyberdream")

-- ==============================================================================
-- 3. APPEARANCE & BACKGROUND
-- ==============================================================================
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.window_background_image = constants.bg_image
config.window_background_image_hsb = {
  brightness = 0.85,
  hue = 1.0,
  saturation = 1.0,
}
config.macos_window_background_blur = 40

-- ==============================================================================
-- 4. PERFORMANCE & USABILITY
-- ==============================================================================
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120
config.animation_fps = 60
config.scrollback_lines = 10000
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ==============================================================================
-- 5. KEYBINDINGS & COMMAND PALETTE
-- ==============================================================================
-- Sends M-Space to tmux when pressing Option + Space (if freed from Gemini app)
config.keys = {
  {
    key = "Space",
    mods = "OPT",
    action = wezterm.action.SendString("\x1b "),
  },
}

wezterm.on("augment-command-palette", function()
  return commands
end)

return config

