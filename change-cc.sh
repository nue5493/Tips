#!/bin/bash -eux

bash="$HOME/.bashrc"
csh="$HOME/.cshrc"

set_file () {
	if [ -f "$1" ] ; then
                cp -f -p "$1" "$1.$(date '+%Y%m%d%H%M%S')"
        else
                touch "$1"
                chmod 0644 "$1"
        fi
        cp -f -p "$1" "$1.tmp"
}

change_shell_bash () {
	if grep -E -v '^\s*#' $1 | grep -E '\balias\s+'$2'=' > /dev/null 2>&1 ; then
   		sed -r -e '/^\s*#/!s/^(.*\balias\s+'$2'=.*)$/#\1/' $1.tmp  > $1.tmp2
   		mv -f $1.tmp2 $1.tmp
	fi	
}

set_file_bash () {
	set_file $1
        change_shell_bash $1 cc
        change_shell_bash $1 gcc  
	echo "alias cc='gcc -g -O2 -Wall -Werror -Wextra -std=c89 -pedantic-errors'"  >> $1.tmp
	echo "alias gcc='gcc -g -O2 -Wall -Werror -Wextra -std=c89 -pedantic-errors'" >> $1.tmp
	mv -f $1.tmp $1
}

change_shell_csh () {
	if grep -E -v '^\s*#' $1 | grep -E '\balias\s+'$2'\s+' > /dev/null 2>&1 ; then
                sed -r -e '/^\s*#/!s/^(.*\balias\s+'$2'\s+.*)$/#\1/' $1.tmp  > $1.tmp2
                mv -f $1.tmp2 $1.tmp
        fi
}

set_file_csh () {
        set_file $1
	change_shell_csh $1 cc
        change_shell_csh $1 gcc
        echo "alias cc 'gcc -g -O2 -Wall -Werror -Wextra -std=c89 -pedantic-errors'"  >> $1.tmp
        echo "alias gcc 'gcc -g -O2 -Wall -Werror -Wextra -std=c89 -pedantic-errors'" >> $1.tmp
        mv -f $1.tmp $1
}

set_file_bash $bash
set_file_csh $csh

echo 'OK!'
exit 0
