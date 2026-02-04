# ---- PATH SETUP ----
# Put ~/.local/bin early, so user binaries override system ones
export PATH="$HOME/.local/bin:$PATH"

# Go environment
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"  # update if needed
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

COLORTERM=truecolor

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

source $HOME/.zsh/zsh-completions.plugin.zsh

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

#plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit load zdharma-continuum/history-search-multi-word

#snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

#completions
autoload -U compinit && compinit
zinit cdreplay -q

#keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

#history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#history styling
zstyle ":history-search-multi-word" highlight-color "bg=yellow,fg=black,bold"
zstyle ":plugin:history-search-multi-word" clear-on-cancel "yes"

#aliases
alias ls='ls --color'

#shell integrations
# fzf key bindings
source /usr/share/doc/fzf/examples/key-bindings.zsh

# fzf completion
source /usr/share/doc/fzf/examples/completion.zsh

eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

# opencode
export PATH=/home/ishan/.opencode/bin:$PATH

#alias
alias n='nvim'
alias v='nvim'
alias vi='nvim'
alias bat='batcat'
alias oc='opencode'

export EDITOR="nvim"
export VISUAL="nvim"
