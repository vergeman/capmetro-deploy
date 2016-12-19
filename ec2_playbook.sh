#!/bin/sh
ansible-playbook ec2_playbook.yml -i ec2.py -v --private-key=~/.ssh/capmetro-deploy.pem
