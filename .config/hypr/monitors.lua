-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

hl.monitor({
  output = "desc:Dell Inc. DELL P2419H BHLQ3Q2",
  mode = "1920x1080@60.00",
  position = "0x0",
  scale = 1.00,
})

hl.monitor({
  output = "desc:Samsung Electric Company Odyssey G85SB H1AK500000",
  mode = "3440x1440@119.96",
  position = "1920x32",
  scale = 1.00,
})

hl.monitor({
  output = "desc:Chimei Innolux Corporation 0x15E7",
  mode = "1920x1080@60.00",
  position = "5360x128",
  scale = 1.00,
})

-- Fallback for any other display
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
