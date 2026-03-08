##################################################################
#                      HAPTIC KORE                               #
#          Developed for bash by Sergio Melas 2026               #
#                                                                #
#                  Email: sergiomelas@gmail.com                  #
#                    Released under GPL V2.0                     #
#                                                                #
##################################################################

Haptic Kore Color Suites (Green / Red / Blue / Cyan / Yellow) are
high-visibility, professional icon themes developed as color-spectrum
forks of the original Haptic project. They combine Material Design
aesthetics with optimized palettes for Linux desktop environments.

---

### THE "COLOR DOMINANT" WORKFLOW
These tools are designed specifically for **Color Dominant Themes**. This
logic applies to icon sets where a specific primary color defines the
identity of folders, devices, and system elements (e.g., "The Blue Theme").

#### 1. Preparation & Safety
To ensure no data is lost during the transformation, follow this setup:
- **Work on a Copy**: Never run the script on your only copy of a theme.
  Create a new folder for your target color and copy the source theme files
  into it first.
- **Placement**: The `recolor_theme.sh` script **must** be placed in the
  same root directory as the theme icons (next to the `index.theme` file).
- **Execution**: You can run the script directly from **Dolphin**. It will
  automatically detect its current directory, making it safe to use without
  opening a terminal.

#### 2. Discovery & Transformation (`recolor_theme.sh`)
This script is the "Universal Transformer" for the suite.
- **Auto-Discovery**: Scans SVGs to detect the exact hex codes and CSS
  attributes (fill, stop-color) of the current source color.
- **Universal Transition**: Moves the theme from any color to any color
  (e.g., Red -> Cyan) seamlessly.
- **Application Safety**: It performs "Internal Surgery" on all icons but
  automatically skips renaming files in `/apps/` and `/categories/`.
  This ensures the icons look right, but apps like Chrome or VLC do
  not lose their links to the icon files.
- **Symlink & Meta Restoration**: Updates internal `index.theme` names,
  directory paths, and reconstructs cascading symlinks.

#### 3. Packaging & Distribution (`debian_packager.sh`)
The professional build tool for the suite.
- **Subfolder Search**: Recursively crawls through all icon size
  directories (16x16, 24x24, Scalable, etc.) to ensure the package
  manifest is 100% accurate.
- **Debian Integration**: Builds the `.deb` structure with correct
  system permissions (755/644) and automated trigger scripts for
  post-install cache updates.

---

CREDITS & ORIGINAL SOURCES:
- Haptic Icons : Developed by Denis Göller (dmgoeller).
- Breeze Icons : Developed by the KDE Community.
- GNOME Colors : Inspiration for symbolic icon sets.
- Material UI  : Color mapping follows official palettes.

INSTALLATION METHODS:

1. DEBIAN PACKAGE (.deb) - Recommended
   Professional installation for Debian, Ubuntu, Mint, and derivatives.
   - Command: `sudo apt install ./haptic-kore-[color]_1.0.0_all.deb`
   - Benefit: Handles system permissions and automated cache updates.

2. MANUAL EXTRACTION (From .deb)
   If you wish to install the files manually, you must extract them
   from the package archive:
   - **Extract Archive**: `ar x haptic-kore-[color]_1.0.0_all.deb`
   - **Unpack Data**: `tar -xvf data.tar.xz` (or data.tar.zst)
   - **Locate Content**: The theme is now in `./usr/share/icons/`

3. MANUAL PLACEMENT
   Once extracted, copy the **Haptic-Kore-[Color]** folder to your
   preferred path:

   **System-wide:**
   - Path: `/usr/share/icons/`
   - Command: `sudo cp -r Haptic-Kore-[Color] /usr/share/icons/`
   - Cache: `sudo ./create-new-icon-theme.cache.sh` (Run inside folder)

   **Local User:**
   - Path: `~/.local/share/icons/`
   - Command: `cp -r Haptic-Kore-[Color] ~/.local/share/icons/`

ACTIVATE: Open your Desktop Tweaks/Appearance tool and select the theme.

##################################################################
Change log:

 - V0.1   12-02-2024: Initial developer version (Blue base).
 - V1.0   07-03-2026: First Public Color Suite releases.
                      Implemented 'recolor_theme.sh' with
                      Universal Transition logic, safe-mode
                      app-masking, and subfolder-aware packaging.
##################################################################
