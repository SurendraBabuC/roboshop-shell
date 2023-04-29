script=$(realpath "$0")
script_path=$(dirname "$script")
source ${ script_path }/common.sh

if [ -z "$mysql_root_password" ]; then
  echo "Input Mysql Root Password Missing"
  exit
fi

func_print_head "Disable mysql 8 Version"
dnf module disable mysql -y &>>${log_file}
func_stat_check $?

func_print_head "Copy mysql repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
func_stat_check $?

func_print_head "Install mysql"
yum install mysql-community-server -y &>>${log_file}
func_stat_check $?

func_print_head "Start mysql service"
systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}
func_stat_check $?

func_print_head "Reset mysql password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>${log_file}
func_stat_check $?
