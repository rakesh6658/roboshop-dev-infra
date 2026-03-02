#!/bin/bash
component=$1
sudo yum install ansible -y
ansible-pull -U https://github.com/rakesh6658/ansible-roboshop-roles-tf.git -i inventory.ini -e component="$component" main.yaml

