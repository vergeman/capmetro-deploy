#!/bin/sh

: ${ENV:?"Need to set ENV (e.g. 'prod')"}
: ${REGION:?"Need to set REGION (e.g. 'us-east-1')"}
: ${AWS_ACCESS_KEY_ID:?"Need AWS_ACCESS_KEY_ID"}
: ${AWS_SECRET_ACCESS_KEY:?"Need AWS_SECRET_ACCESS_KEY"}

#KEYFILE
KEYFILE=~/.ssh/capmetro-deploy.pem

# DB HOST
HOST=`AWS_ACCESS_KEY=$AWS_ACCESS_KEY_ID AWS_SECRET_KEY=$AWS_SECRET_ACCESS_KEY ec2-describe-instances -F 'tag-value=capmetro_db_prod' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1`

# DB name
DBNAME=capmetro

# S3 bucket name & region
BUCKET=capmetro-db-$ENV
REGION=$REGION

# instance user account
USER=ubuntu

# Current time
TIME=`/bin/date +%d-%m-%Y-%T`

# Backup directory
DEST=/mnt/data/capmetro_prod_db_bkup

BKUP_FILE=$DBNAME.$TIME.gz

#Create backup dir (-p to avoid warning if already exists)
`ssh -i $KEYFILE $USER@$HOST "sudo /bin/mkdir -p $DEST"`

# Log
echo "Backing up $HOST/$DBNAME to s3://$BUCKET/ on $TIME";

# Dump from mongodb host into backup directory on prod instance (better bandwith ec2 -> s3)
echo `ssh -i $KEYFILE $USER@$HOST "sudo /usr/bin/mongodump -d $DBNAME --archive=$DEST/$BKUP_FILE --gzip"`

# Upload archive to s3
echo `ssh -i $KEYFILE $USER@$HOST "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY /usr/bin/aws s3 cp --region $REGION $DEST/$BKUP_FILE s3://$BUCKET/"`

# Remove archive
`ssh -i $KEYFILE $USER@$HOST "sudo /bin/rm -f $DEST/$BKUP_FILE"`

# Remove backup directory
`ssh -i $KEYFILE $USER@$HOST "sudo /bin/rm -rf $DEST"`

# All done
echo "Backup available at https://s3.amazonaws.com/$BUCKET/$BKUP_FILE"
echo "Restore: 'sudo mongorestore -d $DBNAME --archive=$DEST/$BKUP_FILE --gzip' "
