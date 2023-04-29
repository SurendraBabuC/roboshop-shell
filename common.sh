app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
# rm -f $log_file

func_print_head() {
  echo -e "\e[36m>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
  echo -e "\e[36m>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<<<\e[0m" &>>${log_file}
}

func_stat_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Refer the log file /tmp/roboshop.log for more information"
    exit 1
  fi
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy Mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    func_stat_check $?

    func_print_head "Install Mongodb client"
    yum install mongodb-org-shell -y &>>${log_file}
    func_stat_check $?

    func_print_head "Load schema"
    mongo --host mongodb-dev.surendrababuc01.online </app/schema/user.js &>>${log_file}
    func_stat_check $?
  fi
  if [ "$schema_setup" == "mysql" ]; then

    func_print_head "Install Mysql client"
    yum install mysql -y &>>${log_file}
    func_stat_check $?

    func_print_head "Load Schema"
    mysql -h mysql-dev.surendrababuc01.online -uroot -p{$mysql_root_password} </app/schema/shipping.sql &>>${log_file}
    func_stat_check $?
  fi
}

func_app_prereq() {
  func_print_head "Add Application User "
  id ${app_user} &>>${log_file}
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>${log_file}
  fi
  func_stat_check $?

  func_print_head "Create Application Directory"
  rm -rf /app &>>${log_file}
  mkdir /app &>>${log_file}
  func_stat_check $?

  func_print_head "Download Application Content"
  curl -L -o /tmp/${componenet}.zip https://roboshop-artifacts.s3.amazonaws.com/${componenet}.zip &>>${log_file}
  func_stat_check $?

  func_print_head "Unzip Application Content"
  cd /app &>>${log_file}
  unzip /tmp/${componenet}.zip &>>${log_file}
  func_stat_check $?
}

func_systemd_setup() {
  func_print_head "Setup Systemd Service"
  cp ${script_path}/${componenet}.service /etc/systemd/system/${componenet}.service &>>${log_file}
  func_stat_check $?

  func_print_head "Start ${componenet} Service"
  systemctl daemon-reload &>>${log_file}
  systemctl enable ${componenet} &>>${log_file}
  systemctl restart ${componenet} &>>${log_file}
  func_stat_check $?
}

func_nodeJs() {
  func_print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  func_stat_check $?

  func_print_head "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "Install NodeJS Dependencies"
  npm install &>>${log_file}
  func_stat_check $?

  func_schema_setup

  func_systemd_setup
}

func_java() {
  func_print_head "Install maven"
  yum install maven -y &>>${log_file} &>>${log_file}
  func_stat_check $?

  func_app_prereq

  func_print_head "Download Maven Dependencies"
  mvn clean package &>>${log_file}
  func_stat_check $?
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}

  func_schema_setup

  func_systemd_setup

}
