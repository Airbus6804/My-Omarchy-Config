-- Personal keybinding overrides (Omarchy 4 / Quattro).

-- Disable default app/webapp shortcuts (from unbind-bindings.conf)
hl.unbind("SUPER + SHIFT + N")
hl.unbind("SUPER + SHIFT + T")
hl.unbind("SUPER + SHIFT + D")
hl.unbind("SUPER + SHIFT + G")
hl.unbind("SUPER + SHIFT + O")
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + SHIFT + SLASH")
hl.unbind("SUPER + SHIFT + C")
hl.unbind("SUPER + SHIFT + E")
hl.unbind("SUPER + SHIFT + Y")
hl.unbind("SUPER + SHIFT + CTRL + G")
hl.unbind("SUPER + SHIFT + P")
hl.unbind("SUPER + SHIFT + X")
hl.unbind("SUPER + SHIFT + ALT + X")

-- Custom bindings (from custom-bindings.conf)
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot to clipboard", "omarchy-cmd-screenshot smart clipboard")

hl.unbind("SUPER + SHIFT + ALT + S")
o.bind("SUPER + SHIFT + ALT + S", "Screenrecord screen", "omarchy-menu toggle screenrecord")

o.bind("SUPER + SHIFT + C", "Color picker", "pkill hyprpicker || hyprpicker -a")

o.bind(
  "SUPER + SHIFT + P",
  "Cursor History",
  os.getenv("HOME") .. "/.config/hypr/latest-cursor-projects-menu.sh/projects-menu.sh"
)
