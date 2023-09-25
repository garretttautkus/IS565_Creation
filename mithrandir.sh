#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# Function to change a user's password
change_password() {
  local user="$1"
  echo -n "Enter the new password for $user: "
  read -s password
  echo
  echo -n "Retype the new password for $user: "
  read -s password2
  echo

  if [ "$password" != "$password2" ]; then
    echo "Passwords do not match. Password not changed."
  else
    echo "$user:$password" | chpasswd
    echo "Password for $user has been changed."
  fi
}

# Get a list of all user accounts (excluding system users)
user_list=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

# Loop through each user and change their password
for user in $user_list; do
change_password "$user"
done
