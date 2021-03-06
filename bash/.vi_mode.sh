# Set vi mode in bash and get some goodies from emacs. Evil Bash
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string ""'
bind 'set vi-cmd-mode-string ">>"'
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-w":unix-word-rubout
bind -m vi-insert "\C-e":end-of-line
bind -m vi-insert "\C-u":unix-line-discard
bind -m vi-insert "\C-k":kill-line
bind -m vi-insert "\C-y":yank
bind -m vi-insert "\C-p":previous-history
bind -m vi-insert "\C-n":next-history
bind -m vi-insert '"\e.":yank-last-arg'
