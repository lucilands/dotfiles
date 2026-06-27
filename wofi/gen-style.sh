#!/bin/bash

COLORS="$HOME/.config/noctalia/colors.json"
OUT="$HOME/.config/wofi/style.css"

if [ ! -f "$COLORS" ]; then
    echo "noctalia colors.json not found: $COLORS" >&2
    exit 1
fi

surface=$(jq -r '.mSurface' "$COLORS")
surface_variant=$(jq -r '.mSurfaceVariant' "$COLORS")
on_surface=$(jq -r '.mOnSurface' "$COLORS")
on_surface_variant=$(jq -r '.mOnSurfaceVariant' "$COLORS")
primary=$(jq -r '.mPrimary' "$COLORS")
outline=$(jq -r '.mOutline' "$COLORS")

cat > "$OUT" << EOF
/* Noctalia — generated from ~/.config/noctalia/colors.json */

* {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 14px;
}

window {
    background-color: ${surface};
    border: 1px solid ${outline};
    border-radius: 10px;
}

#input {
    background-color: ${surface_variant};
    color: ${on_surface};
    border: none;
    border-radius: 8px;
    padding: 8px 12px;
    margin: 10px;
    outline: none;
    caret-color: ${primary};
}

#input:focus {
    border: 1px solid ${primary};
}

#inner-box {
    background-color: transparent;
}

#outer-box {
    padding: 4px;
}

#scroll {
    margin: 0 4px 4px 4px;
}

#entry {
    padding: 6px 10px;
    border-radius: 6px;
    color: ${on_surface_variant};
}

#entry:selected,
#entry:hover {
    background-color: ${surface_variant};
    color: ${on_surface};
}

#entry:selected #text,
#entry:hover #text {
    color: ${primary};
}

#text {
    color: ${on_surface_variant};
}
EOF

echo "wofi style.css updated from noctalia palette"
