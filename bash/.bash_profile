#
# BASH PROFILE
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


# get ssh user (e.g. ssh:(localuser@remotehost))
ssh_user() {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        echo -e " \001\e[1;36m\002ssh:(\001\e[0;38;5;107m\002${USER}@${HOSTNAME}\001\e[1;36m\002)\001\e[0m\002 "
    fi
}

# get current git branch
git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo -e " \001\e[1;36m\002git:(\001\e[0;38;5;107m\002${branch}\001\e[1;36m\002)\001\e[0m\002"
    fi
}

# overwrite bash prompt
export PS1='$(ssh_user)\[\e[38;5;76m\]→  \[\e[31m\]\w\[\e[0m\]$(git_branch) \$ '
