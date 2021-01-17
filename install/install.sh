#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "You need to be logged in as root to install webserver.management"
   exit 1
fi

if ! grep -q Ubuntu "/etc/issue"; then
    echo "Currently only Ubuntu 20.04 is supported by webserver.management"
    exit 1
fi

if [[ $(lsb_release -s -r) != 20.04 ]]; then
    echo "Currently only Ubuntu 20.04 is supported by webserver.management"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "               _                                                                                              _   "
echo " __      _____| |__  ___  ___ _ ____   _____ _ __ _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ ___   ___ _ __ | |_ "
echo " \ \ /\ / / _ \ '_ \/ __|/ _ \ '__\ \ / / _ \ '__| '_ \` _ \ / _\` | '_ \ / _\` |/ _\` |/ _ \ '_ \` _ \ / _ \ '_ \| __|"
echo "  \ V  V /  __/ |_) \__ \  __/ |   \ V /  __/ |_ | | | | | | (_| | | | | (_| | (_| |  __/ | | | | |  __/ | | | |_ "
echo "   \_/\_/ \___|_.__/|___/\___|_|    \_/ \___|_(_)|_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_| |_| |_|\___|_| |_|\__|"
echo "                                                                              |___/                               "

apt update

# Install requirements
apt install -y git zip unzip nginx

# Install PHP
apt install -y software-properties-common
add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get install -y php7.4 \
    php7.4-bcmath \
    php7.4-dom \
    php7.4-fpm \
    php7.4-mbstring \
    php7.4-sqlite3 \
    php7.4-zip

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Create "management" user
useradd -m -s /bin/bash management
usermod -aG www-data management
usermod -aG sudo management

# Configure PHP
sed -i 's/user = www-data/user = management/' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = management/' /etc/php/7.4/fpm/pool.d/www.conf
service php7.4-fpm reload

# Add the management app
cd /home/management/
sudo -H -u management mkdir /home/management/sites
sudo -H -u management mkdir /home/management/sites/management
sudo -H -u management git clone https://github.com/webserver-management/app.git /home/management/sites/management
sudo -H -u management cp /home/management/sites/management/.env.example /home/management/sites/management/.env
sudo -H -u management composer install --working-dir=/home/management/sites/management
sudo -H -u management touch /home/management/sites/management/database/database.sqlite
php /home/management/sites/management/artisan key:generate
php /home/management/sites/management/artisan migrate
cd ~

# Configure Nginx
rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
cp /home/management/sites/management/install/management /etc/nginx/sites-available/management
ln -s /etc/nginx/sites-available/management /etc/nginx/sites-enabled/management
service nginx reload

# Success output
IP=$(hostname -I | cut -d' ' -f1)
clear
echo "                                  _ "
echo "  ___ _   _  ___ ___ ___  ___ ___| |"
echo " / __| | | |/ __/ __/ _ \/ __/ __| |"
echo " \__ \ |_| | (_| (_|  __/\__ \__ \_|"
echo " |___/\__,_|\___\___\___||___/___(_)"
echo ""
echo "------------------------------------------------"
echo "|"
echo "| webserver.management is succesfully installed!"
echo "| Visit in your browser: http://${IP}"
echo "|"
echo "------------------------------------------------"
