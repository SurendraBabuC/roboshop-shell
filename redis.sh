yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y
## address need to change from 127.0.0.0 to 0.0.0.0 in vim /etc/redis.conf & vim /etc/redis/redis.conf
systemctl enable redis
systemctl start redis
