# Capmetro Deploy

### Ansible Scripts to Provision and Deploy Capmetro Crawl

* see jenkins project for jenkins executions.

### Files:

* capmetro_crawl.sh: re-deploys capmetro crawl app from git
* ec2_playbook.sh: configures instance, mounts volume, installs mongo, setup filebeat log
* ec2_provision.sh: provisions ec2 instances, sg, vpc, etc.
* run_vagrant.sh: vagrant equivalent of above builds for dev
* backup_db.sh: mongo -> s3 backup script
