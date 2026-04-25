# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Manage dotfiles
alias gdf='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ldf='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# General aliases
alias hx='helix'
