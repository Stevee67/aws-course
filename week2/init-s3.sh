#!/bin/bash -xe

aws s3api create-bucket --bucket stshysh-course --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
aws s3 cp week2/hello.txt s3://stshysh-course/
aws s3api put-bucket-versioning --bucket stshysh-course --versioning-configuration Status=Enabled