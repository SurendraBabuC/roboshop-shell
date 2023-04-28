app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[36m>>>>>>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
}
func_nodeJs() {
  print_head "Configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install NodeJS"
  yum install nodejs -y

  print_head "Add app user"
  useradd ${app_user}

  print_head "create app directory"
  rm -rf /app
  mkdir /app

  print_head "Download app content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

  print_head "Unzip App Content"
  cd /app
  unzip /tmp/${component}.zip

  print_head "Install NodeJS Dependencies"
  npm install

  print_head Copy Catalogue SystemD file
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head Start User service
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}