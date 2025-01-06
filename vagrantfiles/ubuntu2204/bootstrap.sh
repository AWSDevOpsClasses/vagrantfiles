#!/bin/bash
sudo sed -i '21d' /etc/resolv.conf
sudo sed -i '21i nameserver 8.8.8.8' /etc/resolv.conf
#echo "y" | sudo ufw enable
#sudo ufw allow 8080
# Enable ssh password authentication
echo "Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "Set root password"
echo -e "admin\nadmin" | passwd root >/dev/null 2>&1

