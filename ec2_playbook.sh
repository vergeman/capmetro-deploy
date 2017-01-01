#!/bin/sh

: ${ENV:?"Need to set ENV"}
ansible-playbook ec2_playbook.yml -i ec2.py -vvv --private-key=~/.ssh/capmetro-deploy.pem --extra-vars "env=$ENV"
