
echo "Update the system"
apt update -y

echo "Installing nginx"
apt-get install nginx -y

echo "enable nginx"
systemctl enable nginx --now


echo "go to web root dir of nginx"
cd /var/www/html

echo "create dir"
mkdir site1

echo "go in site1"
cd site1

echo "moving index page"
cat > index.html <<'EOF'
hello this is site 1 and you are in server
EOF

echo "setting permission"
 chown -R $USER:$USER /var/www/html/site1

echo " back to root folder"
cd

echo "copy default conf"
cp /etc/nginx/site-available/default /etc/nginx/site-available/site1.conf

echo "updating the site1.conf file"
sed -i "s/listen 80 default_server/listen 80/g" /etc/nginx/sites-available/site1.conf
sed -i "s/listen [::]:80 default_server/listen [::]:80/g" /etc/nginx/sites-available/site1.conf
sed -i "s_root /var/www/html_root /var/www/html/site1_" /etc/nginx/sites-available/site1.conf
sed -i "s/index.nginx-debian.html/ /g" /etc/nginx/sites-available/site1.conf

echo "remove default"
rm /etc/nginx/sites-enabled/default

echo "enable newly created file"
ln -s /etc/nginx/site-available/site1.conf /etc/nginx/site-enabled

echo "to know if nginx conf is done well"
nginx -t 

echo "restart nginx"
systemctl restart nginx.services