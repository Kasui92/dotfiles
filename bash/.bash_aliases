#
# BASH ALIASES
#

# ls
alias lf="ls -l | egrep -v '^d'"

# System > Update
alias system-update="sudo apt update && sudo apt -y upgrade && sudo apt -y dist-upgrade && sudo apt -y autoremove"
alias firmware-update="sudo fwupdmgr get-devices && sudo fwupdmgr get-updates && sudo fwupdmgr update"

# SSH
ssh-key-put() { cat ~/.ssh/id_ed25519.pub | ssh "$1" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"; }


