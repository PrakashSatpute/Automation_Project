# Automation_Project
Automation Script
This is my First Project
 Writing a bash script to install Apache2 web server on EC2 instance, if not already installed. 
 Then start the service, if service is not already running. 
 Whenever a script is invoked, it should generate a tar file from archival log files located in /var/log/Apache2 folder and uploads to S3 bucket using AWS CLI for periodic archival of Apache2 webserver log files and run this task on a daily basis by creating a cron job.
