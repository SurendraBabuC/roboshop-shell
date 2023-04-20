cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

## address need to change from 127.0.0.0 to 0.0.0.0

systemctl restart mongod