#!/usr/bin/env bash
# Called by the pacman hook (as root). Reads installed package names from stdin,
# then sends a notification via noctalia (D-Bus notify-send) for each logged-in user.

PKGS=$(cat | tr '\n' ' ' | sed 's/[[:space:]]*$//')
[[ -n "$PKGS" ]] || exit 0

for runtime_dir in /run/user/*/; do
    uid=$(basename "$runtime_dir")
    bus="unix:path=${runtime_dir}bus"
    username=$(id -nu "$uid" 2>/dev/null) || continue

    DBUS_SESSION_BUS_ADDRESS="$bus" \
    runuser -u "$username" -- \
        /usr/bin/notify-send --app-name="pacman" --icon="/usr/share/pixmaps/archlinux-logo.svg" \
        "Packages installed" "$PKGS" 2>/dev/null || true
done
