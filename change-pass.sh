#!/bin/bash -eux

user_file="test.txt"
change_line=""
UserID=""
NewPass=""
CurPass=""
Password1=""
Password2=""
Pass=""

check_user () {
	change_line=`cat -n $user_file | grep "$UserID:{CRAM-MD5}"  | sed -r -e 's/'$UserID'.*//'`
	if [ -z $change_line ] ; then
	echo "Not Adress"
	exit 1
	fi
	declare -i change_line=$change_line
}

check_pass () {
	password_protection "CurPass" $CurPass
	check=`cat $user_file | grep $UserID | grep $CurPass`
	if [ -z $check ] ; then
	echo "Miss PassWord"
	exit 1
	fi
}

password_protection () {
	Pass=`doveadm pw -p $2`
	Pass=`echo $Pass | sed -r -e "s/\{CRAM-MD5\}//"`
	if [ $1 = "NewPass" ] ; then 
		NewPass=$Pass
	elif [ $1 = "CurPass" ] ; then 
		CurPass=$Pass
	fi
}

set_new_pass () {
	stty -echo
	echo "New Password:"
	read Password1
	echo "Retype Password:"
	read Password2
	stty echo
	if [ $Password1 != $Password2 ] ; then
		echo "MissType Password"
		exit 1
	else
		password_protection "NewPass" $Password1
		sed -i -r -e "$change_line s/$CurPass:/$NewPass:/" $user_file
	fi
}

echo "Please Input Your MailAdress"
read UserID
check_user
echo "Please Input Your Current PassWord"
stty -echo
read CurPass
stty echo
check_pass
set_new_pass

echo 'Change Password!!'
exit 0
