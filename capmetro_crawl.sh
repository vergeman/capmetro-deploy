#!/bin/sh
ansible-playbook ec2_playbook.yml -i ec2.py -vvv --private-key=~/.ssh/capmetro-deploy.pem --extra-vars "env=prod" --tags "deploy_app"
