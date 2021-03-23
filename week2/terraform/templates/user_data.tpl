#!/bin/bash -xe
apt-get update -y
apt-get install -y awscli
aws s3 cp s3://stshysh-course/hello.txt /