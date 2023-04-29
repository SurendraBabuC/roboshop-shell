script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Copying the mongo repo"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
func_stat_check $?

func_print_head "Installing mongodb"
yum install mongodb-org -y &>>${log_file}
func_stat_check $?

func_print_head "Updating listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_file}
func_stat_check $?

func_print_head "Enabling mongodb Service"
systemctl enable mongod &>>${log_file}
func_stat_check $?

func_print_head "Restarting mongodb Service"
systemctl restart mongod &>>${log_file}
func_stat_check $?