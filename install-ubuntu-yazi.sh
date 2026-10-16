#!/bin/bash
# installs the yazi terminal file manager plus its preview/viewer dependencies,
# and adds the y() wrapper (cd to yazi's cwd on exit) to ~/.zshrc.local and ~/.bashrc.local
# https://github.com/sxyazi/yazi
# https://yazi-rs.github.io/docs/installation
set -e

for dep in apt-get apt-cache curl dpkg; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "missing required dependency: $dep"
    exit 1
  fi
done

ARCH="$(dpkg --print-architecture)"
if [ "$ARCH" != "amd64" ] && [ "$ARCH" != "arm64" ]; then
  echo "unsupported architecture: $ARCH (yazi apt repo provides amd64 and arm64 only)"
  exit 1
fi

KEYRING=/usr/share/keyrings/yazi-keyring.gpg
SOURCES=/etc/apt/sources.list.d/yazi.list

if [ ! -f "$KEYRING" ]; then
  echo "adding yazi apt keyring"
  curl -fsSL https://yazi-rs.github.io/builds/yazi-keyring.gpg | sudo tee "$KEYRING" >/dev/null
fi

if [ ! -f "$SOURCES" ]; then
  echo "adding yazi apt repository"
  echo "deb [signed-by=$KEYRING] https://yazi-rs.github.io/builds/ stable main" | sudo tee "$SOURCES" >/dev/null
fi

echo "updating apt"
sudo apt-get update

# viewers/helpers yazi uses for previews, search, and clipboard:
#   file (required), ffmpeg (video), 7zip (archives), jq (json), poppler-utils (pdf),
#   fd-find + ripgrep (search), fzf + zoxide (navigation), resvg (svg),
#   imagemagick (fonts/heic/jxl), chafa (image fallback for terminals without image protocols),
#   xclip/xsel/wl-clipboard (clipboard)
WANTED=(
  yazi
  file
  ffmpeg
  7zip
  jq
  poppler-utils
  fd-find
  ripgrep
  fzf
  zoxide
  resvg
  imagemagick
  chafa
  xclip
  xsel
  wl-clipboard
)

# package names differ across ubuntu releases; install only what apt can provide
PACKAGES=()
for pkg in "${WANTED[@]}"; do
  if [ "$pkg" = "7zip" ] && ! apt-cache show 7zip >/dev/null 2>&1; then
    pkg=p7zip-full
  fi
  if apt-cache show "$pkg" >/dev/null 2>&1; then
    PACKAGES+=("$pkg")
  else
    echo "skipping unavailable package: $pkg"
  fi
done

echo "installing: ${PACKAGES[*]}"
sudo apt-get install -y "${PACKAGES[@]}"

# ubuntu ships fd as fdfind; yazi expects fd
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  echo "linking fdfind to ~/.local/bin/fd"
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

for rc in "$HOME/.zshrc.local" "$HOME/.bashrc.local"; do
  touch "$rc"
  if grep -q "^function y()" "$rc"; then
    echo "y() already present in $rc"
    continue
  fi
  echo "adding y() to $rc"
  cat >>"$rc" <<'EOF'

# yazi: run with y, cd into the directory yazi was in on exit
function y() {
	local tmp cwd
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}
EOF
done

yazi --version
echo "done. open a new shell (or source your rc file) and run y"
