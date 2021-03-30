#!/bin/bash -xe

aws dynamodb list-tables --region us-west-2

aws dynamodb put-item \
    --table-name Table1 \
    --item \
        '{"FirstName": {"S": "Stepan"}, "LastName": {"S": "Shysh"}, "UserId": {"S": "1ec587a8-6f69-4064-8f83-64b778ddae2d"}}' \
    --region us-west-2

aws dynamodb scan --table-name Table1 --region us-west-2