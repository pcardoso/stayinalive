#!/bin/sh

# to do:
# add keychain support
# get dc automatically -- 
# To locate your PDC, run findsmb. The system listed with an asterisk is the Domain Master Browser, or PDC.

# mail last changed password in case of failure

# to getPassw()
# 	tell application "Keychain Scripting"
# 		launch
# 		tell current keychain to ¬
# 			tell (some generic key whose name is "truztruzpass")
# 				return password as string
# 			end tell
# 	end tell
# end getPassw
# 
# set passwd to getPassw()

dc="10.0.0.0"

# Pedro Cardoso:
	# echo %LOGONSERVER%
# 
# Rui Roque:
# 	\\XXXXXXXXXX


username=${1}

read -p "Password for $username? " password

# keep the original password
pass=$password

for i in 4 3 2 1 0
do
	if [ $i -eq "0" ]; then
		rnd=$password
	else
		rnd="$password$i"
	fi
	chg="$pass\n$rnd\n$rnd"
	echo "tmp password: " $rnd
	(echo $chg | smbpasswd -U $username -s -r $dc) || exit 1
	pass=$rnd
	# be nice
	sleep 1
done

echo "ok!"
