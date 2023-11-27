#
# BASH FUNCTIONS
#

function md() {
    mkdir -p $1
    cd $1
}

function ssh-key-put() { 
    cat ~/.ssh/id_ed25519.pub | ssh "$1" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"; 
}
