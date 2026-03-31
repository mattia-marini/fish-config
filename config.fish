# System specific config
set config_dir (status dirname)
if test -f $config_dir/system.fish
    source $config_dir/system.fish
end

# Setup LuaRocks path
eval (luarocks path)

# Starship prompt
starship init fish | source
eval (starship completions fish)
enable_transience

#mise
mise activate fish | source
# eval "$(flox activate)"
flox activate -d /Users/mattia/ --print-script | source # activate current env or default


if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set up PATH
# set -gx PATH /Users/mattia/Library/Mobile\ Documents/com~apple~CloudDocs/Workspaces/utility_scripts $PATH
# set -gx PATH $PATH /opt/homebrew/Cellar/lua-language-server/3.16.17
# set -gx PATH /Applications/kitty.app/Contents/MacOS $PATH
# set -gx PATH /Applications/CMake.app/Contents/bin $PATH
# set -gx PATH $HOME/.emacs.d/bin $PATH
# set -gx PATH /Applications/Emacs.app/Contents/MacOS $PATH
# set -gx PATH $PATH $HOME/.cargo/bin
# set -gx PATH $PATH /Users/mattia/.local/bin
# fish_add_path /opt/homebrew/opt/llvm/bin


# Aliases
alias listvimdir='printf "PLUGGED:/Users/mattia/.local/share/nvim/plugged\nRUNTIME: /opt/homebrew/Cellar/neovim/0.8.0/share/nvim\nCONFIG:/Users/mattia/.config/nvim\n"'
alias Cws='cd /Users/mattia/Documents/c++_workspace'
alias cws='cd /Users/mattia/Documents/c_workspace'
alias tree='eza --tree --level=2'
alias ls='eza --icons'
alias conf='cd ~/.config'
alias cpp='cd /Users/mattia/Library/Mobile\ Documents/com~apple~CloudDocs/Workspaces/cpp_workspace/Università'
alias javaw='cd /Users/mattia/Library/Mobile\ Documents/com~apple~CloudDocs/Workspaces/java_workspace'
alias latex='cd /Users/mattia/Library/Mobile\ Documents/com~apple~CloudDocs/Workspaces/latex_workspace'
alias js='cd /Users/mattia/Library/Mobile\ Documents/com~apple~CloudDocs/Workspaces/js'
alias py='cd /Users/mattia/Library/Mobile\ Documents/com~apple~CloudDocs/Workspaces/python_workspace'
alias emacs='emacsclient -c -a nvim'
alias DT='tput clear; printf "\033[3J"; printf "\033[0;0H"'


abbr -a gaa git add --all
abbr -a gcm 'git commit -m"'
abbr -a mgh 'git clone https://github.com/mattia-marini/'

bind --mode visual y '"*y'

# Kitty specific integration
if test -n "$KITTY_PID"
  bind space,h "kitten @ focus-window --match=neighbor:left --no-response"
  bind space,l "kitten @ focus-window --match=neighbor:right --no-response"
  bind space,k "kitten @ focus-window --match=neighbor:top --no-response"
  bind space,j "kitten @ focus-window --match=neighbor:bottom --no-response"
end


function my_f
  fish_vi_key_bindings default
end
set -g fish_key_bindings my_f

set fish_greeting ""

fish_config theme choose everforest



# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
