#!/bin/sh
ansible-playbook capmetro_crawl.yml -i ec2.py -vvv --private-key=~/.ssh/capmetro-deploy.pem
