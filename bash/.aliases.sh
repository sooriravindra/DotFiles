#!/bin/bash

# Use the right utility to extract any archive. 
# From https://medium.com/@aarohmankad/1e91b4ca0298, slightly modified

extract() {
    if [ -z "$1" ]; then 
        # display usage if no parameters given 
        echo "Usage: extract <path/file_name>" 
    else 
        if [ -f $1 ] ; then 
            # NAME=${1%.*} 
            # mkdir $NAME && cd $NAME 
            case $1 in 
                *.tar.bz2)   set -x; tar xvjf ./$1    ;; 
                *.tar.gz)    set -x; tar xvzf ./$1    ;; 
                *.tar.xz)    set -x; tar xvJf ./$1    ;; 
                *.lzma)      set -x; unlzma ./$1      ;; 
                *.bz2)       set -x; bunzip2 ./$1     ;; 
                *.rar)       set -x; unrar x -ad ./$1 ;; 
                *.gz)        set -x; gunzip ./$1      ;; 
                *.tar)       set -x; tar xvf ./$1     ;; 
                *.tbz2)      set -x; tar xvjf ./$1    ;; 
                *.tgz)       set -x; tar xvzf ./$1    ;;
                *.zip)       set -x; unzip ./$1       ;;
                *.Z)         set -x; uncompress ./$1  ;;
                *.7z)        set -x; 7z x ./$1        ;;
                *.xz)        set -x; unxz ./$1        ;;
                *.exe)       set -x; cabextract ./$1  ;;
                *.zst)       set -x; zstd --decompress ./$1  ;;
                *)           echo "extract: '$1' - unknown archive method" ;;
            esac
            { set +x; } 2>/dev/null
        else
            echo "$1 - file does not exist"
        fi
    fi
}

# Open search query in default browser
s() {
    url="https://google.com/search?q="
    query=`echo $@`
    echo "$url$query"
    xdg-open "$url$query" &>/dev/null &
}

# Open file / url
o() {
    if [ -z "$1" ]; then 
        echo "Usage: o <path/file_name>" 
    else 
        if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
            # Windows Subsystem for Linux
            powershell.exe /C start "$1"
        else
            xdg-open "$1" &>/dev/null &
        fi
    fi
}

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -ltr'
alias grep='grep --color=auto'
alias ironcity='compas -t "~/bin/ironcity_attach"'
alias ec='emacsclient -n -r -a ""'

# Remove things that depend on xdg-open
if [[ -z $(command -v xdg-open) ]]; then
    unset s;
    unset o;
fi

