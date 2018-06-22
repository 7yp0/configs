source /usr/local/git/contrib/completion/git-completion.bash
source /usr/local/git/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true

# Colors for the prompt
blue="\033[0;34m"
white="\033[0;37m"
green="\033[0;32m"
red="\033[0;31m"
yellow="\033[0;33m"

# Brackets needed around non-printable characters in PS1
ps1_blue='\['"$blue"'\]'
ps1_green='\['"$green"'\]'
ps1_white='\['"$white"'\]'
ps1_yellow='\['"$yellow"'\]'

parse_git_branch() {
    gitstatus=`git status 2> /dev/null`
    if [[ `echo $gitstatus | grep "Changes to be committed"` != "" ]]
    then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1***)/' | sed "s/*/`printf "${green}"`&`printf "${white}"`/g"
    elif [[ `echo $gitstatus | grep "Changes not staged for commit"` != "" ]] 
    then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1**)/' | sed "s/*/`printf "${yellow}"`&`printf "${white}"`/g"
    elif [[ `echo $gitstatus | grep "Untracked"` != "" ]]
    then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1*)/' | sed "s/*/`printf "${yellow}"`&`printf "${white}"`/g"
    elif [[ `echo $gitstatus | grep "nothing to commit"` != "" ]]
    then
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    else
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1?)/'
    fi
}

# Echo a non-printing color character depending on whether or not the current git branch is the master    
# Does NOT print the branch name                                                                          
# Use the parse_git_branch() function for that.                                                           
parse_git_branch_color() {
    br=$(parse_git_branch)

    if [[ $br =~ production.* || $br =~ release.* || $br =~ master.* ]]; then
        echo -e "${red}"
    elif [[ $br =~ develop.* ]]; then
        echo -e "${yellow}"
    else
        echo -e "${green}"
    fi
}

# With color:
export PS1="$ps1_blue\u@\h:$ps1_white\w$\[\$(parse_git_branch_color)\]\$(parse_git_branch) $ps1_blue\$$ps1_white "
