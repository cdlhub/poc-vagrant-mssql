#!/bin/bash

echo "##### 1. Updating system..."
yum update -y # > /dev/null 2>&1
yum upgrade -y # > /dev/null 2>&1
echo "#### 1. Done."
echo ""

echo "##### 2. Installing MS SQL Server..."
curl https://packages.microsoft.com/config/rhel/7/mssql-server.repo > /etc/yum.repos.d/mssql-server.repo
yum install -y mssql-server
echo "#### 2. Done."
echo ""

echo "##### 3. Seting up MS SQL Server..."
export SA_PASSWORD='sa_pa$$w0rd'
/opt/mssql/bin/sqlservr-setup --accept-eula --set-sa-password --enable-service --start-service
echo "#### 3. Done."
echo ""

echo "##### 4. Installing MS SQL tools..."
curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/msprod.repo
export ACCEPT_EULA=Y
yum install mssql-tools -y
echo "#### 4. Done."
echo ""

echo "#### 5. Creating DB..."
mkdir /mssql-data
chown mssql /mssql-data
chgrp mssql /mssql-data
sqlcmd -S localhost -U SA -P 'sa_pa$$w0rd' -i /vagrant/scripts/create-db.sql
echo "#### 5. Done."
echo ""
