script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Install Golang <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install golang -y

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Add Application User <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Create Application Directory <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Download Application Content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Unzip Application Content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Download the Dependencies and Build the Software <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Copy Dispatch Systemd Service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp /dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>>>>>>>>>>>>> Start Dispatch Service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch