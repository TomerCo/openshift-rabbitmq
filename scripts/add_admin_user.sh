#!/bin/bash

if [ -z $2 ]; then 
	echo "Usage: $0 <user> <password>"
	exit 0
	
fi

echo "Adding user $1...."

/usr/sbin/rabbitmqctl list_user_permissions  $1 &> /dev/null
if [ $? -eq 70 ]; then
 #user does not exist
	/usr/sbin/rabbitmqctl add_user $1 $2
	if [ $? -ne 0 ]; then
		echo "ERROR - failed to add admin user" 
		exit 1
	fi
	/usr/sbin/rabbitmqctl  set_permissions -p / $1 ".*" ".*" ".*"
	if [ $? -ne 0 ]; then
		echo "ERROR - failed to set admin permissions" 
		exit 2
	fi	
	/usr/sbin/rabbitmqctl set_user_tags $1 administrator
	if [ $? -ne 0 ]; then
		echo "ERROR - failed to set administrator tag on user" 
		exit 3
	fi	
else
	echo "User $1 already exists"
fi



