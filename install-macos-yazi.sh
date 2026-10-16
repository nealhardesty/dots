#!/bin/bash
# installs the yazi terminal file manager plus its preview/viewer dependencies,
# and adds the y() wrapper (cd to yazi's cwd on exit) to ~/.zshrc.local and ~/.bashrc.local
# https://github.com/sxyazi/yazi
# https://yazi-rs.github.io/docs/installation
set -e

if ! command -v brew >/dev/null 2>&1; then
  echo "missing required dependency: brew (run install-macos-homebrew.sh first)"
  exit 1
fi

# viewers/helpers yazi uses for previews, search, and navigation:
#   ffmpeg (video), sevenzip (archives), jq (json), poppler (pdf),
#   fd + ripgrep (search), fzf + zoxide (navigation), resvg (svg),
#   imagemagick (fonts/heic/jxl), chafa (image fallback for terminals without image protocols)
# file and the clipboard (pbcopy/pbpaste) ship with macos
PACKAGES=(
  yazi
  ffmpeg
  sevenzip
  jq
  poppler
  fd
  ripgrep
  fzf
  zoxide
  resvg
  imagemagick
  chafa
)

echo "updating homebrew"
brew update

echo "installing: ${PACKAGES[*]}"
brew install "${PACKAGES[@]}"

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
