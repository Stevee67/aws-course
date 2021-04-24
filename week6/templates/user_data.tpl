#!/bin/bash -xe
yum update -y
yum install -y java-1.8.0-openjdk

aws s3 cp s3://stshysh-course/calc-2021-0.0.2-SNAPSHOT.jar .
java -jar calc-2021-0.0.2-SNAPSHOT.jar
