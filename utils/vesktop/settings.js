const fs = require("fs")

const vestkop_settings_file = process.env.HOME + "/.config/vesktop/settings/settings.json"


const settings = JSON.parse(fs.readFileSync(vestkop_settings_file, "utf8"))

settings.plugins.oneko = {
    enabled: true,
}

settings.enabledThemes = [ 'system24-Sapphire.css' ]

fs.writeFileSync(vestkop_settings_file, JSON.stringify(settings, null, 2))
