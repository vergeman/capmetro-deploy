#!/bin/sh
ansible-playbook ec2_provision.yml -i ec2.py -c paramiko -vvv --private-key=~/.ssh/capmetro-deploy.pem --extra-vars "env=prod"
