#!/bin/bash

# Define colors
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Prompt for installation confirmation
echo -e "${GREEN}Apakah Anda ingin melakukan Installasi Nginx, MySQL, dan PHP? (Y/N)${NC}"
read -n 1 -p "" CONFIRMATION
echo

if [[ $CONFIRMATION != "Y" && $CONFIRMATION != "y" ]]; then
    echo -e "${YELLOW}Installasi dibatalkan.${NC}"
    exit 1
fi

# Update package lists
echo -e "${YELLOW}Updating package lists...${NC}"
sudo apt-get update -y

# Install prerequisites for adding PHP PPA
echo -e "${YELLOW}Installing prerequisites for adding PHP PPA...${NC}"
sudo apt-get install software-properties-common -y

# Add PHP PPA
echo -e "${YELLOW}Adding PHP PPA repository...${NC}"
sudo add-apt-repository ppa:ondrej/php -y

# Update package lists again after adding PPA
echo -e "${YELLOW}Updating package lists after adding PHP PPA...${NC}"
sudo apt-get update -y

# Display PHP version options
echo -e "${BLUE}Select PHP version(s) to install:${NC}"
echo -e "${BLUE}1) PHP 5.6${NC}"
echo -e "${BLUE}2) PHP 7.4${NC}"
echo -e "${BLUE}3) PHP 8.2${NC}"
echo -e -n "${GREEN}Enter version(s) (e.g., 1,2,3 or 1,3): ${NC}"
read PHP_SELECTION

# Convert comma-separated input to an array
IFS=',' read -r -a VERSIONS <<< "$PHP_SELECTION"

# Install selected PHP versions and required extensions
for VERSION in "${VERSIONS[@]}"; do
    case $VERSION in
        1)
            echo -e "${YELLOW}Installing PHP 5.6 and required extensions...${NC}"
            sudo apt-get install php5.6-fpm php5.6-mysql php5.6-curl php5.6-gd php5.6-mbstring php5.6-xml php5.6-xmlrpc php5.6-soap php5.6-intl php5.6-zip -y
            ;;
        2)
            echo -e "${YELLOW}Installing PHP 7.4 and required extensions...${NC}"
            sudo apt-get install php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-xmlrpc php7.4-soap php7.4-intl php7.4-zip -y
            ;;
        3)
            echo -e "${YELLOW}Installing PHP 8.2 and required extensions...${NC}"
            sudo apt-get install php8.2-fpm php8.2-mysql php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-xmlrpc php8.2-soap php8.2-intl php8.2-zip -y
            ;;
        *)
            echo -e "${YELLOW}Invalid option: $VERSION${NC}"
            ;;
    esac
done

# Prompt for MySQL root password
echo -e -n "${GREEN}Enter MySQL root password: ${NC}"
read -sp '' MYSQL_ROOT_PASSWORD
echo

# Install MySQL server
echo -e "${YELLOW}Installing MySQL Server...${NC}"
sudo DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y

# Secure MySQL installation
echo -e "${YELLOW}Configuring MySQL root password...${NC}"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install Nginx
echo -e "${YELLOW}Installing Nginx...${NC}"
sudo apt-get install nginx -y

# Enable and start services
echo -e "${YELLOW}Enabling and starting Nginx and MySQL services...${NC}"
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl enable mysql
sudo systemctl start mysql

echo -e "${YELLOW}LEMP stack installation completed.${NC}"
