# Custom Config

A personal configuration setup script for Arch Linux that automates the installation and configuration of development tools, system settings, and desktop environment customizations.

## What It Does

This project provides a unified setup script that installs and configures:

### Development Tools

- **NVM (Node Version Manager)**: Installs NVM v0.39.2 and sets up Node.js
- **Cursor Editor**: Installs Cursor via `yay` package manager

### Desktop Environment

- **Hyprland Window Manager**: Configures Hyprland with custom settings including:
  - Workspace configurations
  - Monitor settings
  - Language/keyboard layouts
  - Custom keybindings
  - Rice (visual customization) settings

- **Background Images**: Injects custom background images from the project's theme directory into omarchy themes

### Applications

- **Vesktop (Discord Client)**: 
  - Installs Vesktop via `yay`
  - Copies custom themes (system24-Sapphire.css)
  - Configures plugins (enables oneko plugin)

### Shell Configuration

- **Bash Aliases**: Sets up custom command aliases:
  - `raspi-ssh`: SSH connection to Raspberry Pi
  - `vik-api`: Mount and open vikschool-api project
  - `leadsystem`: Open leadsystem-comparacorsi project

- **Extended Bashrc**: 
  - Adds scripts directory to PATH
  - Loads NVM automatically
  - Sources custom aliases

## Installation

Run the main setup script:

```bash
./setup.sh
```

The script will:
1. Make all utility scripts executable
2. Install and configure NVM with Node.js
3. Inject background images into omarchy themes
4. Configure Hyprland window manager
5. Install and setup Vesktop
6. Install Cursor editor
7. Inject extended bashrc configuration into `~/.bashrc`

## Requirements

- Arch Linux (or Arch-based distribution)
- `yay` AUR helper installed
- Bash shell

