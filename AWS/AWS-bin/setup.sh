sudo yum -y update
sudo yum -y install java-1.7.0-openjdk-devel
sudo yum -y install tomcat7
sudo service tomcat7 start
sudo yum -y install tomcat7-webapps tomcat7-docs-webapp tomcat7-admin-webapps
sudo yum -y install mlocate
sudo updatedb