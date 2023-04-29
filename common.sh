app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[36m>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy Mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    func_print_head "Install Mongodb client"
    yum install mongodb-org-shell -y

    func_print_head "Load schema"
    mongo --host mongodb-dev.surendrababuc01.online </app/schema/user.js
  fi
  if [ "$schema_setup" == "mysql" ]; then

    func_print_head "Install Mysql client"
    yum install mysql -y

    func_print_head "Load Schema"
    mysql -h mysql-dev.surendrababuc01.online -uroot -p{$mysql_root_password} </app/schema/shipping.sql
  fi
}

func_app_prereq() {
  func_print_head "Add Application User "
  useradd ${app_user}

  func_print_head "Create Application Directory"
  mkdir /app

  func_print_head "Download Application Content"
  curl -L -o /tmp/${componenet}.zip https://roboshop-artifacts.s3.amazonaws.com/${componenet}.zip

  func_print_head "Unzip Application Content"
  cd /app
  unzip /tmp/${componenet}.zip
}

func_systemd_setup() {
  func_print_head "Setup Systemd Service"
  cp ${script_path}/${componenet}.service /etc/systemd/system/${componenet}.service

  func_print_head "Start ${componenet} Service"
  systemctl daemon-reload
  systemctl enable ${componenet}
  systemctl restart ${componenet}
}

func_nodeJs() {
  func_print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "Install NodeJS"
  yum install nodejs -y

  func_app_prereq

  func_print_head "Install NodeJS Dependencies"
  npm install

  func_schema_setup

  func_systemd_setup
}

func_java() {
  func_print_head "Install maven"
  yum install maven -y

  func_app_prereq

  func_print_head "Download Maven Dependencies"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup

  func_systemd_setup

}
