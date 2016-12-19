#!/bin/sh
ansible-playbook ec2_provision.yml -i ec2.py -c paramiko -v --private-key=~/.ssh/capmetro-deploy.pem
