source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Install Python <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Unzip Application Content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Install Dependencies <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Copy Payment Systemd Service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Start Payment Service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
