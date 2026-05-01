export PATH=$PATH:/home/lucius/.local/bin
eval "$(oh-my-posh init zsh --config ~/.zshtheme.json)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init - zsh)"
#eval "$(pyenv virtualenv-init - zsh)"


alias reload='source ~/.zshrc'
alias rcedit='nvim ~/.zshrc'
alias ls='eza --color=always --icons=always --header --git'
alias mawk='gawk'
alias ttysolitaire="ttysolitaire --no-background-color -p 999999"

export LS_COLORS=$(vivid generate catppuccin-mocha)
export EDITOR=nvim
export FZF_COMPLETION_TRIGGER='**'

# zsh plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source <(fzf --zsh)

cowsay -r $(misfortune -s)
