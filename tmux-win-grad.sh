#!/bin/bash
IDX=$1
read ACTIVE TOTAL < <(tmux display-message -p '#{window_index} #{session_windows}')
DIST=$(( IDX > ACTIVE ? IDX - ACTIVE : ACTIVE - IDX ))

ROUND_L=$'\xee\x82\xb6'
ROUND_R=$'\xee\x82\xb4'

MAX_LEFT=$(( ACTIVE - 1 ))
MAX_RIGHT=$(( TOTAL - ACTIVE ))
MAX_DIST=$(( MAX_LEFT > MAX_RIGHT ? MAX_LEFT : MAX_RIGHT ))

if [ "$MAX_DIST" -le 0 ]; then exit 0; fi

# Start: #585b70  End: #2a2b3d
SR=108; SG=112; SB=134
ER=56;  EG=58;  EB=82

R=$(( SR + (ER - SR) * DIST / MAX_DIST ))
G=$(( SG + (EG - SG) * DIST / MAX_DIST ))
B=$(( SB + (EB - SB) * DIST / MAX_DIST ))

COLOR=$(printf '#%02x%02x%02x' $R $G $B)

echo "#[fg=${COLOR},bg=default]${ROUND_L}#[bg=${COLOR}] #[fg=${COLOR},bg=default]${ROUND_R}"
