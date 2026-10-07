#!/bin/bash

# Install the Tsoding i3 theme for Omarchy: the theme itself, its two bar
# widgets, the theme-set hook that swaps the bar, and the packages they need.
# Run it from a checkout, or pipe it from GitHub and it clones itself first.

set -euo pipefail

REPO_URL="https://github.com/SVIGHNESH/omarchy-tsoding-theme.git"
THEME_NAME="tsoding"
PACKAGES=(ttc-iosevka i3status)

OMARCHY_CONFIG="$HOME/.config/omarchy"
THEME_PATH="$OMARCHY_CONFIG/themes/$THEME_NAME"
PLUGINS_PATH="$OMARCHY_CONFIG/plugins"
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.lua"

fail() {
  echo -e "\e[31mError: $1\e[0m" >&2
  exit 1
}

step() {
  echo -e "\e[32m==>\e[0m $1"
}

command -v omarchy-theme-set >/dev/null || fail "Omarchy was not found. This theme only works on Omarchy."
command -v omarchy-shell >/dev/null || fail "omarchy-shell was not found. This theme needs Omarchy 4 or newer."
[[ -f $HYPRLAND_CONFIG ]] || fail "$HYPRLAND_CONFIG was not found. This theme needs Omarchy's Lua Hyprland config."

# Use the checkout this script sits in, or clone one when piped from curl.
SOURCE_PATH=""
if [[ -n ${BASH_SOURCE[0]:-} && -f $(dirname "${BASH_SOURCE[0]}")/colors.toml ]]; then
  SOURCE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
else
  CLONE_PATH=$(mktemp -d)
  trap 'rm -rf "$CLONE_PATH"' EXIT
  step "Downloading the theme"
  git clone --quiet --depth 1 "$REPO_URL" "$CLONE_PATH"
  SOURCE_PATH=$CLONE_PATH
fi

step "Installing packages: ${PACKAGES[*]}"
omarchy-pkg-add "${PACKAGES[@]}"

# Copied without .git, so Omarchy treats it as your own theme and keeps its Lua.
step "Installing the theme to $THEME_PATH"
rm -rf "$THEME_PATH"
mkdir -p "$THEME_PATH"
cp -r "$SOURCE_PATH/backgrounds" "$THEME_PATH/"
cp "$SOURCE_PATH"/*.toml "$SOURCE_PATH"/*.lua "$SOURCE_PATH"/*.conf "$SOURCE_PATH"/*.json \
  "$SOURCE_PATH/icons.theme" "$SOURCE_PATH/preview.png" "$THEME_PATH/"

step "Installing the bar widgets"
mkdir -p "$PLUGINS_PATH"
# Copied over an existing install in place: the running shell drops a widget
# from the bar layout the moment its plugin directory disappears.
for plugin in "$SOURCE_PATH"/plugins/*/; do
  mkdir -p "$PLUGINS_PATH/$(basename "$plugin")"
  cp -r "$plugin". "$PLUGINS_PATH/$(basename "$plugin")/"
done

step "Installing the theme-set hook"
omarchy-hook-install theme-set "$SOURCE_PATH/hooks/tsoding-i3bar" >/dev/null

# Omarchy loads a theme's hyprland.lua before your own looknfeel.lua, so the
# i3 look needs one line at the end of hyprland.lua to load after it.
if ! grep -q "hyprland-final.lua" "$HYPRLAND_CONFIG"; then
  step "Adding the theme override loader to $HYPRLAND_CONFIG"
  cp "$HYPRLAND_CONFIG" "$HYPRLAND_CONFIG.bak.$(date +%s)"
  cat >>"$HYPRLAND_CONFIG" <<'LUA'

-- Let the current theme have the last word over the personal overrides above when it ships a hyprland-final.lua.
do local path = os.getenv("HOME") .. "/.local/state/omarchy/current/theme/hyprland-final.lua"; local file = io.open(path, "r"); if file then file:close(); dofile(path) end end
LUA
fi

step "Applying the theme"
omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
omarchy-theme-set "$THEME_NAME"

echo
echo "Tsoding theme installed. Log out and back in once so the title bars pick up Iosevka."
echo "Switch back any time with: omarchy theme set <name>"
