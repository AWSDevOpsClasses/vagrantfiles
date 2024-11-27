#!/bin/bash
sudo sed -i '21d' /etc/resolv.conf
sudo sed -i '20i nameserver 8.8.8.8' /etc/resolv.conf
echo "y" | sudo ufw enable
sudo ufw allow 8080

sudo apt-get update -y
sudo apt install wget -y
#sudo apt install fontconfig openjdk-17-jre -y
#sudo apt install default-jdk -y
#sudo apt install openjdk-21-jdk -y
sudo apt install fontconfig openjdk-17-jre -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
