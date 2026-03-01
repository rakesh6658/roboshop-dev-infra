#!/bin/bash
sudo yum install ansible -y
ansible-pull -U https://github.com/rakesh6658/ansible-roboshop-roles-tf.git -e component="mongodb" main.yaml

