#!/bin/bash
FLOATING=$(hyprctl activewindow -j | jq -r '.floating')
hyprctl dispatch togglefloating
if [ "$FLOATING" = "false" ]; then
    hyprctl dispatch resizeactive exact 1080 720
fi
