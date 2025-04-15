echo "Loading macos catalina config"

# Set Homebrew environment (Apple Silicon)
/usr/local/bin/brew shellenv | source

# Latex suite path
set -gx PATH $PATH /Library/TeX/texbin
