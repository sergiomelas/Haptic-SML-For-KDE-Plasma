##################################################################
#                        sml magic tools                         #
#        Developed for for bash by sergio melas 2026             #
#                                                                #
#                Email: sergiomelas@gmail.com                    #
#                    Released under GPL V2.0                     #
#                                                                #
##################################################################

Haptic Kore Color Suites (Green / Red / Blue) are high-visibility,
professional icon themes developed as color-spectrum forks of the
original Haptic project. They combine Material Design aesthetics
with optimized color palettes for Linux desktop environments.

NEW IN VERSION 1.0:
- Complete color-base migration (Green/Red/Blue) from Blue (#4285f4).
- Recursive metadata injection for index.theme (Safe-Mode).
- Automatic filename/folder renaming for theme-specific structures.
- Automated GTK icon cache synchronization and Debian packaging.

CREDITS & ORIGINAL SOURCES:

- Haptic Icons : Developed by Denis Göller (dmgoeller).
                 Source: https://github.com/dmgoeller/haptic-icons
- Breeze Icons : Developed by the KDE Community.
                 Source: https://github.com/KDE/breeze-icons
- GNOME Colors : Inspiration for symbolic icon sets.
                 Source: https://github.com
- Material UI  : Color mapping follows official Material Design
                 palettes to ensure accessibility and contrast.

COLOR SCHEME SPECIFICATIONS:

- Primary Base : Shifted from Material Blue to Forest Green or Ruby Red.
- Gradients    : Linear stop-colors transitioned to maintain contrast.
- Compatibility: Designed to inherit from Breeze-Dark/Light.

INSTALLATION METHODS:

1. DEBIAN PACKAGE (.deb) - Recommended
   Professional installation for Debian, Ubuntu, Mint, and derivatives.
   - Command: sudo apt install ./haptic-kore-[color]_1.0.0_all.deb
   - Benefit: Handles system-wide permissions, automated cache
              updates, and easy uninstallation via 'apt remove'.

2. MANUAL INSTALLATION (System-wide)
   - Path:    /usr/share/icons/
   - Unpack the [Color] you want to install, unzip the .deb file, then
     the data.tar.xz copy the content of /usr/share/icons/ in the file in
     /usr/share/icons/
   - Command: sudo cp -r Haptic-Kore-[Color] /usr/share/icons/
   - Cache:   sudo gtk-update-icon-cache -f /usr/share/icons/Haptic-Kore-[Color]

3. MANUAL INSTALLATION (Local User)
   - Path:    ~/.local/share/icons/
   - Command: cp -r Haptic-Kore-[Color] ~/.local/share/icons/
   - Cache:   gtk-update-icon-cache -f ~/.local/share/icons/Haptic-Kore-[Color]

ACTIVATE: Open your Desktop Tweaks/Appearance tool and select the theme.

##################################################################
Change log:

 -V0.1   12-02-2024: Initial developer version (Blue base) plus
                     several additions and modifications.
 -V1.0   26-01-2026: First Public Color Suite releases.
                     Implemented Packager, safe-mode
                     renaming, and automated cache rebuilds.
##################################################################
