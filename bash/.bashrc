#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


check_and_source () {
    [ -f $1 ] && source $1
}

[ -e ~/.dircolors ] && eval $(dircolors -b ~/.dircolors)
[ -n $(command -v vim) ] && export EDITOR=vim
[ -n $(command -v firefox) ] && export BROWSER=firefox
[ -d ~/bin ] && [[ ":$PATH:" != *"`readlink -f ~/bin`"* ]] && PATH="`readlink -f ~/bin/`:${PATH}"

PROMPT_COMMAND="dirs | awk '{ print \"[\"\$1\"]\"}'"
HISTCONTROL=ignorespace
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]: '

check_and_source ~/.vi_mode.sh
check_and_source ~/.aliases.sh
check_and_source ~/.fzf.bash
check_and_source ~/.hidden.sh
