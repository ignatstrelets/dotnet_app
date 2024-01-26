#!/bin/bash
cd /home/app &&
aws s3 cp s3://dotnet-app-build-artifact/dotnet_app.zip . &&
unzip dotnet_app.zip &&
rm dotnet_app.zip
export SECRET_ARN="<secret_arn>"
export DB_HOST=$(aws secretsmanager get-secret-value \
--secret-id "$SECRET_ARN" \
--query SecretString --output text | jq -r '."DB_HOST"')
export DB_NAME=$(aws secretsmanager get-secret-value \
--secret-id "$SECRET_ARN" \
--query SecretString --output text | jq -r '."DB_NAME"')
export DB_USERNAME=$(aws secretsmanager get-secret-value \
--secret-id "$SECRET_ARN" \
--query SecretString --output text | jq -r '."DB_USERNAME"')
export DB_PASSWORD=$(aws secretsmanager get-secret-value \
--secret-id "$SECRET_ARN" \
--query SecretString --output text | jq -r '."DB_PASSWORD"')
systemctl import-environment DB_HOST DB_NAME DB_USERNAME DB_PASSWORD
systemctl restart promtail
systemctl enable promtail
systemctl restart dotnet-app

