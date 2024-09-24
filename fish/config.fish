if status is-interactive
    # Commands to run in interactive sessions can go here
end
#fish_add_path /opt/nvim-linux64/bin
fish_add_path /usr/local/go/bin
#fish_add_path $HOME/go/bin
fish_add_path $HOME/tools/bin

oh-my-posh init fish | source
oh-my-posh init fish --config /home/ipotashev/.config/omp/fily7.omp.json | source

set FNM_PATH $HOME/.local/share/fnm
set NVM_DIR $HOME/.nvm
set GOROOT /usr/local/go
set GOPATH $HOME/DEV/go


alias cat bat

alias ls exa
alias ll "ls -l"
alias la "ls -la"
alias l ll

alias nvim "flatpak run io.neovim.nvim"
alias vim nvim
alias vi nvim
alias v nvim

alias cls clear
alias py python3

alias c_fish "v $HOME/.config/fish/config.fish"
alias lg lazygit

alias dup "docker-compose up -d"
alias dstop "docker-compose stop"
alias ddown "docker-compose down"
alias devs "sh scripts/copy_ssh.sh && docker-compose up -d && docker exec -it \$(basename \"\$PWD\")_station_1 tmux"
