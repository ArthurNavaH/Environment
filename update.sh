#!/bin/bash
mkdir logs &>/dev/null
now=$(date +"%F+%T")
log_file="logs/update-$now.log"
sudo rm logs/update-* &>/dev/null

if [ ! -x "$0" ]; then
    echo "[Updater Error] : Execute permissions are required (+x)" | tee -a "$log_file"
    echo "exit 1" | tee -a "$log_file"
    exit 1
fi

main() {
    # check install all
    if [ "$update_all" == 1 ]; then
        update_editor=1
        update_console=1
    fi

    if [ "$update_editor" != 1 ] && [ "$update_console" != 1 ]; then
        echo "[Updater Error] : List of update:"
        echo -e "\t all" | tee -a "$log_file"
        echo -e "\t editor" | tee -a "$log_file"
        echo -e "\t console" | tee -a "$log_file"
        echo "exit 1" | tee -a "$log_file"
        exit 1
    fi

    # check requireds
    if [ "$update_editor" == 1 ]; then
        requiredSudoCommands snap
        requiredCommands nvim node npm

        #--- check node version
        nodeVersion="$(node --version | cut -d'.' -f1)"; nodeVersion="${nodeVersion#'v'}"
        if [ "$nodeVersion" -lt 11 ]; then
            echo "[Editor Updater Error] : NodeJs version must be higher than v11.0.0 ( >= v12.0.0)" | tee -a "$log_file"
            echo "exit 1" | tee -a "$log_file"
            exit 1
        fi

        #--- check go env
        if [ -z "$(go env GOROOT)" ]; then
            echo "[Editor Updater Error] : The GOROOT environment variable is not set" | tee -a "$log_file"
            echo "exit 1" | tee -a "$log_file"
            exit 1
        fi
        if [ -z "$(go env GOPATH)" ]; then
            echo "[Editor Updater Error] : The GOPATH environment variable is not set" | tee -a "$log_file"
            echo "exit 1" | tee -a "$log_file"
            exit 1
        fi
    fi
    if [ "$update_console" == 1 ]; then
        requiredSudoCommands snap apt
    fi

    echo "" | tee -a "$log_file"
    echo "[Fonts Updater] : Updating fonts..." | tee -a "$log_file"
    sudo mkdir -p /usr/local/share/fonts/arthurFonts | tee -a "$log_file"
    sudo cp ./fonts/* /usr/local/share/fonts/arthurFonts/. | tee -a "$log_file"
    sudo fc-cache -f -v &>/dev/null | tee -a "$log_file"
    echo "[Fonts Updater] : ----------------------" | tee -a "$log_file"

    # installs
    if [ "$update_editor" == 1 ]; then
        echo "[Editor Updater] : Update Editor..." | tee -a "$log_file"

        updateEditor
    fi

    if [ "$update_console" == 1 ]; then
        echo "[Console Updater] : Update Console..." | tee -a "$log_file"

        updateConsole
    fi
}

# clean arguments
for a; do
   shift
   case $a in
   -*) opts+=("$a");;
   *) set -- "$@" "$a";;
   esac
done
# set vars with arguments
for p in "$@"; do
    if [ "$p" == "editor" ]; then
        update_console=1
    fi
    if [ "$p" == "console" ]; then
        update_console=1
    fi
    if [ "$p" == "all" ]; then
        update_all=1
    fi
done;
if [ "$#" == 0 ]; then
    update_all=1
fi

# requiredCommands terminates the execution if there are no commands
requiredCommands() {
    concatMissingCommand=""
    for p in "$@"; do
        if ! p_tmp="$(type -p "$p")" || [[ -z $p_tmp ]]; then
            concatMissingCommand+="\t$p\n"
        fi
    done;

    if [[ -n $concatMissingCommand ]]; then 
        echo "[Updater Error] : Commands are required:" | tee -a "$log_file"
        echo -e "$concatMissingCommand" | tee -a "$log_file"
        echo "exit 1" | tee -a "$log_file"
        exit 1
    fi
}

# requiredSudoCommands terminates the execution if no 'sudo' commands exist
requiredSudoCommands() {
    concatMissingCommand=""
    for p in "$@"; do
        if ! p_tmp="$(sudo which "$p")" || [[ -z $p_tmp ]]; then
            concatMissingCommand+="\tsudo $p\n"
        fi
    done;

    if [[ -n $concatMissingCommand ]]; then 
        echo "[Updater Error] : Commands with SUDO are required:" | tee -a "$log_file"
        echo -e "$concatMissingCommand" | tee -a "$log_file"
        echo "exit 1" | tee -a "$log_file"
        exit 1
    fi
}

# updateEditor update editor
updateEditor() {
    sudo snap refresh vim-editor nvim | tee -a "$log_file"

    # copy configurations
    cp config/vimrc ~/.vim/. | tee -a "$log_file"
    cp config/init.vim ~/.config/nvim/. | tee -a "$log_file"
    cp config/coc-settings.json ~/.config/nvim/. | tee -a "$log_file"

    # install updates
    nvim --headless +"call dein#install()" +qall | tee -a "$log_file"
    nvim --headless +"call dein#update()" +qall | tee -a "$log_file"
    nvim --headless +"call dein#remote_plugins()" +qall | tee -a "$log_file"
    nvim --headless +UpdateRemotePlugins +qall | tee -a "$log_file"
    nvim --headless +GoInstallBinaries +qall | tee -a "$log_file"
    nvim --headless +GoUpdateBinaries +qall | tee -a "$log_file"
    nvim --headless +CocUpdate +qall | tee -a "$log_file"

    echo "[Editor Updater] : + Update editor successful! +" | tee -a "$log_file"
}

# updateConsole update console
updateConsole() {
    sudo snap refresh alacritty | tee -a "$log_file"
    sudo apt install --only-upgrade tmux zsh | tee -a "$log_file"

    # copy configurations
    cp config/alacritty.yml ~/.config/alacritty/. | tee -a "$log_file"
    cp config/.zshrc ~/. | tee -a "$log_file"
    cp config/.tmux.conf ~/. | tee -a "$log_file"

    bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh | tee -a "$log_file"

    echo "[Console Updater] : + Update console successful! +" | tee -a "$log_file"
}

main "$@"
