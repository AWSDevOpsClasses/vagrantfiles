#!/bin/bash
sudo sed -i '21d' /etc/resolv.conf
sudo sed -i '20i nameserver 8.8.8.8' /etc/resolv.conf
#echo "y" | sudo ufw enable
#sudo ufw allow 8080
sudo apt-get update -y
sudo apt install wget -y
#sudo apt install fontconfig openjdk-17-jre -y
#sudo apt install default-jdk -y
sudo apt install openjdk-21-jdk -y
#sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.31/bin/apache-tomcat-10.1.31.tar.gz
sudo wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.33/bin/apache-tomcat-10.1.33.tar.gz
sudo mkdir -p /opt/tomcat
sudo tar xzvf apache-tomcat-*tar.gz -C /opt/tomcat --strip-components=1
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'
sudo cat << EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat webs servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat
RestartSec=10
Restart=always 
Environment="JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64/"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

sudo sed -i '/<\/tomcat-users>/ i\<role rolename="admin-gui,manager-gui,manager-script,manager-jmx,manager-status"/>' /opt/tomcat/conf/tomcat-users.xml
sudo sed -i '/<\/tomcat-users>/ i\<user username="admin" password="admin123" roles="admin-gui,manager-gui,manager-script"/>' /opt/tomcat/conf/tomcat-users.xml

sudo sed -i '21d;22d' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo sed -i '21d;22d' /opt/tomcat/webapps/host-manager/META-INF/context.xml

sudo systemctl daemon-reload
sudo systemctl restart tomcat
