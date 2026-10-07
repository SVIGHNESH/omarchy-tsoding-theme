#!/bin/bash

# Remove everything install.sh added, except the ttc-iosevka and i3status packages.

set -euo pipefail

THEME_NAME="tsoding"
OMARCHY_CONFIG="$HOME/.config/omarchy"
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.lua"

# The hook restores your bar and font when another theme is set, so that has
# to happen before the hook is removed.
if [[ $(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null) == "$THEME_NAME" ]]; then
  echo "The Tsoding theme is active. Switch to another theme first:" >&2
  echo "  omarchy theme set <name>" >&2
  exit 1
fi

rm -rf "$OMARCHY_CONFIG/themes/$THEME_NAME"
rm -rf "$OMARCHY_CONFIG/plugins/vighnesh.i3-workspaces" "$OMARCHY_CONFIG/plugins/vighnesh.i3status"
rm -f "$OMARCHY_CONFIG/hooks/theme-set.d/tsoding-i3bar"

if [[ -f $HYPRLAND_CONFIG ]]; then
  sed -i '/^-- Let the current theme have the last word over the personal overrides/d; /hyprland-final\.lua/d' "$HYPRLAND_CONFIG"
fi

omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true

echo "Tsoding theme removed."
echo "The packages stay installed. Remove them with: sudo pacman -Rns ttc-iosevka i3status"
