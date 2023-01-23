echo creatingscript>/tmp/script.log
apt update -y
apt install nginx -y
cd /etc/nginx/sites-enabled
sed -i 's/80/8080/g' default 
systemctl restart nginx
echo done>>/tmp/script.log

