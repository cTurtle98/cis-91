#!/bin/bash

# creating groups
echo "[]******** creating groups..."

echo "******** cis191"
addgroup -gid 1201 cis191

echo "******** hobbits"
addgroup -gid 1600 hobbits

echo "******** elves"
addgroup -gid 1700 elves

echo "******** dwarves"
addgroup -gid 1800 dwarves

echo "******** wizards"
addgroup -gid 1900 wizards


# creating user accounts
echo "[]******** creating user accounts"
# useradd
# -N dont create group with same name as username
# -p <password>
# -u user id
# -g group id
# -G additional groups
# -c full name

echo "******** cis191"
useradd -N -m -p Cabr11o -u 1201 -G wizards -g 1201 -c "CIS191" cis191 

echo "******** frodo"
useradd -N -m -p Cabr11o -u 1601 -g 1600 -c "Frodo Baggins" -s '/bin/bash' frodo

echo "******** gollum"
useradd -N -m -p Cabr11o -u 1602 -g 1600 -c "Smeagol" -d "/home/smeagol" gollum

echo "******** legolas"
useradd -N -m -p Cabr11o -u 1701 -g 1700 -c "Legolas of Mirkwood" -s '/bin/zsh' legolas

echo "******** gimli"
useradd -N -m -f 0 -u 1801 -g 1800 -c "Gimli son of Gloin" -s '/bin/bash' gimli
passwd -d gimli

# reset password
echo "[]******** reset password"

echo "******** frodo"
passwd -e frodo


# modify name/identity
echo "[]******** modify name/identity"

echo "******** edit frodo group"
usermod frodo -g users
usermod frodo -aG hobbits


echo "******** edit legolas"
usermod legolas -l glorfindel

echo "******** edit gimli"
usermod -u 1800 gimli


# locking account
echo "[]******** locking account"

echo "******** lock legolas"
usermod -L glorfindel

# Customizing a login environment¶
echo "[]******** login enviroment"

echo "******** issue file"
echo "Middle Earth Linux 1.0." > /etc/issue

echo "******** motd"
echo " this class is CIS 191 and that all activity on this computer is closely monitored." > /etc/motd

echo "******** hush login"
touch /home/gimli/.hushlogin
chown gimli:dwarves /home/gimli/.hushlogin


# deleting user account
echo "[]******** delete a user"

echo "******** archive user files"
tar -czvf /var/preserve/gollum.tar /home/smeagol/

echo "******** delete gollum"
userdel -r gollum

echo "[]******** DONE"