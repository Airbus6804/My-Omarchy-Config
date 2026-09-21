-- Personal input overrides (Omarchy 4 / Quattro).

hl.config({
  input = {
    kb_layout = "us,it",
    kb_options = "compose:caps,grp:alts_toggle",
    touchpad = {
      natural_scroll = true,
    },
  },
})

-- Touchpad gestures (from gestures.conf)
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "1" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
