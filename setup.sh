#!/bin/bash

# Uses stow to setup the packages. And install Plug (Plugin manager) and other vim plugins.
# A package is installed simply as "stow -t ~ package"
# To uninstall "stow -t ~ --delete package"

echo -n "Looking for stow... "
command -v stow || (echo "Stow not found! Please install stow"; exit)
echo "Found :)"
echo

destination=~
function confirm_action {
    echo "$1"
    read -r -p ">> [Y/n] " response  
    response=${response,,} # tolower  
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then     
        eval $2
    else
        echo "Skipping.."
    fi    
}

for package in "vim" "tmux" "bash" "xbindkeys"
do
    package_string="Stow $package to $destination ? Package contains $(echo ; ls -A $package)"
    confirm_action "$package_string" "stow -t  $destination $package"
done

confirm_action "Install Plug for Vim?" "curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim"
confirm_action "Install Vim plugins now?" "vim +PlugInstall +qall"
echo ""
echo ""
echo "========================================="
echo "     d88888b d888888b d8b   db           "
echo "     88'       '88'   888o  88           "
echo "     88ooo      88    88V8o 88           "
echo "     88~~~      88    88 V8o88           "
echo "     88        .88.   88  V888 db        "
echo "     YP      Y888888P VP   V8P VP        "
echo "========================================="
echo ""
