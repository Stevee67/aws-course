#!/bin/bash -xe
apt-get update -y
apt-get install -y awscli
apt-get install -y postgresql-client
aws s3 cp s3://stshysh-course/dynamodb-script.sh /
aws s3 cp s3://stshysh-course/rds-script.sql /