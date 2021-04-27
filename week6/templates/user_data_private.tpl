#!/bin/bash -xe
yum update -y
yum install -y java-1.8.0-openjdk

export RDS_HOST=${rds_host}
aws s3 cp s3://stshysh-course/persist3-2021-0.0.1-SNAPSHOT.jar .
java -jar persist3-2021-0.0.1-SNAPSHOT.jar