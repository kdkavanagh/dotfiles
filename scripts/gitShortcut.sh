#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/utils.sh

user ' - Path to git repos [~/git]: '
read -e gitdir
eval MY_GIT_DIR=${gitdir:-~/git}
if [ ! -d "$MY_GIT_DIR" ]; then
    fail "Directory '$MY_GIT_DIR' does not exist"
fi
export MY_GIT_DIR=$MY_GIT_DIR

user ' - Single-letter shortcut to use (e.g `k <repo name>) [k]:  '
read -e shortcut
eval MY_GIT_SHORTCUT=${shortcut:-k}
fn="function $MY_GIT_SHORTCUT() { cd $MY_GIT_DIR/\$1; }; \
_$MY_GIT_SHORTCUT() { local cur=\${COMP_WORDS[COMP_CWORD]}; local opts=\$(find $MY_GIT_DIR/* -maxdepth 1 -type d -prune | xargs -I {} basename {} | tr '\n' ' '); COMPREPLY=( \$(compgen -W \"\$opts\" -- \$cur) ); }; \
complete -F _$MY_GIT_SHORTCUT $MY_GIT_SHORTCUT;"

echo "$fn" > ~/.gitShortcut.sh
success 'Git Shortcut'
