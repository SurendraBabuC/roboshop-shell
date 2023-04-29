script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Installing nginx WebServer"
yum install nginx -y &>>${log_file}
func_stat_check $?

func_print_head "Enabling nginx Service"
systemctl enable nginx &>>${log_file}
func_stat_check $?

func_print_head "Restarting nginx Service"
systemctl restart nginx &>>${log_file}
func_stat_check $?

func_print_head "Copy nginx Reverse Proxy Conf file"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
func_stat_check $?

func_print_head "Removing default content from nginx server"
rm -rf /usr/share/nginx/html/* &>>${log_file}
func_stat_check $?

func_print_head "Downloading the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
func_stat_check $?

func_print_head "Extracting the frontend content"
cd /usr/share/nginx/html &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}
func_stat_check $?

func_print_head "Restarting nginx Service"
systemctl restart nginx &>>${log_file}
func_stat_check $?
