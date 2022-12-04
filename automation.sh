#!/bin/bash

# Variables
name="prakash"
s3_bucket="upgrad-prakash"

# update the ubuntu repositories
apt update -y

# Check if apache2 is installed
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]]; then
        apt install apache2 -y
 fi

# apache2 service is running or not
running=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()') 
if [[ running != ${running} ]]; then

       systemctl start apache2
 fi

# apache2 Service is enabled or not
enabled=$(systemctl is-enabled apache2 | grep "enabled") 
if [[ enabled != ${enabled} ]]; then
        systemctl enable apache2
 fi

# Check if AWS-CLI is already installed or not, if not install it:
dpkg -s awscli
 if [ $? -eq 0 ]
 then
    echo "AWS-CLI is already installed." 
else
    echo "Installing AWS-CLI..."
    sudo apt install awscli -y 
fi

# Creating file name

timestamp=$(date '+%d%m%Y-%H%M%S')

# Create tar archive of apache2 access and error logs
cd /var/log/apache2 
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

# copy logs to s3 bucket
if [[ -f /tmp/${name}-httpd-logs-${timestamp}.tar ]]; then
          aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
fi

#task3

docroot="/var/www/html"

# Check if inventory file exists
if [[ ! -f ${docroot}/inventory.html ]]; then
	echo -e 'Log Type\t-\tTime Created\t-\tType\t-\tSize' > ${docroot}/inventory.html 
fi

# Inserting Logs into the file
if [[ -f ${docroot}/inventory.html ]]; then
    size=$(du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}')

echo -e "httpd-logs\t-\t${timestamp}\t-\ttar\t-\t${size}" >> ${docroot}/inventory.html 
fi

# Create a cron job that runs service every minutes/day
if [[ ! -f /etc/cron.d/automation ]]; then
	echo "* * * * * root /root/Automation_Project/automation.sh" >> /etc/cron.d/automation 

fi
