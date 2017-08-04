setopt promptsubst

# Machine name.
function box_name {
[ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

# Git state
function parse_git_dirty {
  ( [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] &&
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working tree clean" ]] ) &&
    echo ":(" || echo ":)"
}
function parse_git_branch {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[ \1 $(parse_git_dirty) ]/"
}

# Working directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(parse_git_branch)'
local git_last_commit='<$(git log --pretty=format:"%h \"%s\"" -1 2> /dev/null)>'

# Ruby Version
local ruby_version='$(ruby -v | cut -d " " -f 1,2)'

# Prompt format: \n # TIME USER at MACHINE in [DIRECTORY] on git:BRANCH STATE \n $

PROMPT="
%{$fg[cyan]%}%n\
%{$fg[white]%}@\
%{$fg[green]%}$(box_name)\
%{$fg[white]%}:\
%{$terminfo[bold]$fg[yellow]%}[$current_dir]%{$reset_color%} using\
 %{$fg[cyan]%}[$ruby_version]%{$reset_color%} on\
 ${git_info}\
  $git_last_commit
%{$fg[red]%}%* \
  %{$terminfo[bold]$fg[white]%}¯\_(ツ)_/¯ %{$reset_color%}"

