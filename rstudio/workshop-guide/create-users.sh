#!/bin/bash

# Path to the CSV file
csv_file="workshop_users.csv"

folder_to_copy="/home/ubuntu/workshop"


# create group rstudio-users
sudo groupadd rstudio-users
sudo usermod -aG rstudio-users ubuntu


# Read the CSV file and create user accounts
{
  read -r _ # Skip the header row
  while IFS=',' read -r username password
  do
      # Create the user account
      sudo useradd -m -p $(echo "$password" | openssl passwd -1 -stdin) -s /bin/bash "$username"
      
      # Add the user to the desired user groups
      sudo usermod -aG rstudio-users "$username"

      # Copy the folder to the user's home directory
      sudo cp -R "$folder_to_copy" "/home/$username"
      sudo chown -R "$username:$username" "/home/$username/$(basename "$folder_to_copy")"
  done
} < "$csv_file"