-- Personal look and feel overrides (Omarchy 4 / Quattro).

hl.config({
  decoration = {
    rounding = 8,
  },
})

-- Layer rules (from rice.conf — Omarchy 4 bar namespace)
hl.layer_rule({ match = { namespace = "omarchy-bar" }, blur = true, ignore_alpha = 0.1 })
