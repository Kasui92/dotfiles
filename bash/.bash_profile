#
# BASH PROFILE
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# overwrite bash prompt
function parse_git_branch() {
    CYAN='\033[0;36m'
    OLIVE='\033[0;33m'
    NO_COLOR='\033[0m'

    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
    	echo -e "${CYAN}git:(${NO_COLOR}${OLIVE}${BRANCH}${NO_COLOR}${CYAN})${NO_COLOR} "
    else
    	echo ""
    fi
}

PS1='\[\e[38;5;76m\]→  \[\e[31m\]\w\[\e[0m\] $(parse_git_branch)/$ '
