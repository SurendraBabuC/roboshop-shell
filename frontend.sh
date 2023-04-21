echo -e "\e[36m>>>>>>>>>>>>>>>>>> Installing nginx WebServer <<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Enabling nginx Service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable nginx

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Restarting nginx Service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart nginx

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Copy nginx Reverse Proxy Conf file <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Removing default content from nginx server <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Downloading the frontend content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Extracting the frontend content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Restarting nginx Service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl restart nginx
