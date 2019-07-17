#!/bin/bash
destination=~
function confirm_action {
    echo $1
    read -r -p ">> [Y/n] " response  
    response=${response,,} # tolower  
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then     
        eval $2
    else
        echo "Skipping.."
    fi    
}

for file in ".vi_mode.sh" ".tmux.conf" ".vimrc"
do
    confirm_action "Copy $file to $destination/" "cp $file $destination/$file"
done

confirm_action "Add vi_mode to bashrc?" "echo 'source ~/.vi_mode.sh' >> ~/.bashrc"
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

# TODO
# Add aliases.sh
