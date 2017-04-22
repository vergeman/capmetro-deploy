#!/bin/sh -xe

: ${ENV:?"Need to set ENV"}

#add tag arg
if [ -z ${TAGS} ]; then TAGS=all; else echo "limiting tasks to: $TAGS"; fi

ansible-playbook ec2_playbook.yml -i ec2.py -vvv --private-key=~/.ssh/capmetro-deploy.pem --tags="$TAGS" --extra-vars "env=$ENV"
