-- Personal input overrides (Omarchy 4 / Quattro).

hl.config({
  input = {
    kb_layout = "us,it",
    kb_options = "compose:caps,grp:alts_toggle",
    touchpad = {
      natural_scroll = true,
      -- Right click on lower-right click zone, not two-finger click (Omarchy default).
      clickfinger_behavior = false,
      -- Hyprland/libinput: no per-finger tap toggle — off disables 2-finger (and 1-finger) tap.
      tap_to_click = false,
    },
  },
})

-- Touchpad gestures (from gestures.conf)
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "1" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
