#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── helpers ────────────────────────────────────────────────────────────────────

info() { printf '\033[0;34m[info]\033[0m  %s\n' "$*"; }
ok()   { printf '\033[0;32m[ ok ]\033[0m  %s\n' "$*"; }
warn() { printf '\033[0;33m[warn]\033[0m  %s\n' "$*"; }
die()  { printf '\033[0;31m[err ]\033[0m  %s\n' "$*" >&2; exit 1; }

# Creates (or updates) a symlink, backing up any real file that's in the way.
symlink() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "Backing up $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sfn "$src" "$dst"
    ok "Linked $dst"
}

# ── sanity checks ──────────────────────────────────────────────────────────────

[[ "$(uname -s)" == "Linux" ]] || die "Arch Linux only."
command -v pacman &>/dev/null  || die "pacman not found – is this Arch Linux?"

# ── yay ───────────────────────────────────────────────────────────────────────

if ! command -v yay &>/dev/null; then
    info "Installing yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    _tmp=$(mktemp -d)
    git clone --depth=1 https://aur.archlinux.org/yay.git "$_tmp/yay"
    (cd "$_tmp/yay" && makepkg -si --noconfirm)
    rm -rf "$_tmp"
    ok "yay installed"
fi

# ── packages ───────────────────────────────────────────────────────────────────

PACMAN_PKGS=(
    # Hyprland stack
    hyprland
    hyprpaper
    hyprlock
    hyprpolkitagent
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # Audio
    pipewire
    pipewire-pulse
    wireplumber
    playerctl

    # Display / input
    brightnessctl
    grim slurp swappy      # screenshots

    # Terminal & shell
    kitty
    tmux
    zsh
    fzf
    eza
    jq
    cowsay
    git
    base-devel

    # Editor
    neovim

    # Apps
    dolphin
    wofi
    rofi
)

AUR_PKGS=(
    noctalia-qs        # provides 'qs', the noctalia shell runner
    noctalia-shell     # noctalia bar / compositor shell
    brave-bin          # browser
    oh-my-posh-bin     # shell prompt
    vivid              # LS_COLORS generator
    misfortune         # fortune variant used in .zshrc
)

info "Installing pacman packages..."
sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}"

info "Installing AUR packages..."
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# ── git submodules ─────────────────────────────────────────────────────────────

info "Initialising git submodules..."
git -C "$DOTFILES" submodule update --init --recursive
ok "Submodules ready"

# ── symlinks ───────────────────────────────────────────────────────────────────

info "Creating symlinks..."

# ~/.config/ directory links
symlink "$DOTFILES/hypr"             "$HOME/.config/hypr"
symlink "$DOTFILES/nvim"             "$HOME/.config/nvim"
symlink "$DOTFILES/waybar"           "$HOME/.config/waybar"
symlink "$DOTFILES/wofi"             "$HOME/.config/wofi"

# kitty (file inside an otherwise unmanaged dir)
mkdir -p "$HOME/.config/kitty"
symlink "$DOTFILES/kitty.conf"       "$HOME/.config/kitty/kitty.conf"

# tmux
symlink "$DOTFILES/.tmux.conf"       "$HOME/.tmux.conf"

# zsh
symlink "$DOTFILES/.zshrc"           "$HOME/.zshrc"
symlink "$DOTFILES/.zsh"             "$HOME/.zsh"
symlink "$DOTFILES/lucilands.omp.json" "$HOME/.zshtheme.json"

# ── pacman notification hook ───────────────────────────────────────────────────

info "Installing pacman notification hook (needs sudo)..."
sudo mkdir -p /etc/pacman.d/hooks
sudo cp "$DOTFILES/pacman_notif.hook" /etc/pacman.d/hooks/notif.hook
sudo install -m 755 "$DOTFILES/pacman-notify.sh" /usr/local/bin/pacman-notify.sh
ok "Pacman hook installed"

# ── hyprpm plugins ─────────────────────────────────────────────────────────────
# hyprbars is used in hyprland.conf. hyprpm needs Hyprland running to enable
# plugins, so this just registers the repo; run 'hyprpm enable hyprbars' inside
# a Hyprland session if it doesn't auto-load.

if command -v hyprpm &>/dev/null; then
    info "Registering hyprland-plugins with hyprpm..."
    hyprpm update -n 2>/dev/null || true
    hyprpm add https://github.com/hyprwm/hyprland-plugins 2>/dev/null || true
    ok "hyprpm: run 'hyprpm enable hyprbars' inside Hyprland to activate"
else
    warn "hyprpm not found – install hyprland first, then run: hyprpm add https://github.com/hyprwm/hyprland-plugins"
fi

# ── wofi theme ─────────────────────────────────────────────────────────────────

info "Generating wofi style from noctalia palette..."
if [[ -f "$HOME/.config/noctalia/colors.json" ]]; then
    bash "$DOTFILES/wofi/gen-style.sh"
else
    warn "noctalia colors.json not found – run gen-style.sh after installing noctalia"
fi

# ── shell ──────────────────────────────────────────────────────────────────────

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    info "Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
    ok "Shell changed – takes effect on next login"
fi

# ── done ───────────────────────────────────────────────────────────────────────

echo
ok "Install complete."
info "Next steps:"
info "  1. Reboot (or log out) and select Hyprland from your display manager."
info "  2. Inside Hyprland, run: hyprpm enable hyprbars"
info "  3. Open noctalia settings to pick your colour scheme."
