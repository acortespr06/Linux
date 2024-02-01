# Piwigo Installation and Configuration Script

This script is designed to automate the installation and configuration of a Piwigo photo gallery website on a Linux server running the Ubuntu operating system. Piwigo is an open-source photo gallery software that allows you to create and manage your own photo gallery website.

## Script Purpose

The script performs the following tasks:

1. **Update Server**: It updates the package list and upgrades installed packages on the server using the `apt update` and `apt upgrade` commands.

2. **Install Required Packages**: The script installs essential packages such as `curl` and `unzip` using the `apt install` command.

3. **Install LAMP Server**: It installs a LAMP (Linux, Apache, MySQL, PHP) stack on the server, which includes Apache web server, MariaDB database server, and PHP with necessary extensions. It also adjusts some PHP configuration settings for memory limit and file upload size.

4. **Create a Database for Piwigo**: The script creates a MySQL database named `piwigo`, a MySQL user `piwigo` with the password `123Admin`, and grants necessary privileges to the user for the database.

5. **Install Piwigo**: It downloads the latest Piwigo release, extracts it, and moves it to the Apache web server's document root directory. It also sets appropriate ownership and permissions for Piwigo files.

6. **Configure Apache for Piwigo**: The script creates an Apache virtual host configuration file for Piwigo, specifying the document root and server name. It enables the site configuration and enables the Apache rewrite module for URL rewriting.

7. **Restart Apache**: The script restarts the Apache web server to apply the configuration changes.

8. **Completion Message**: It displays a message indicating the successful completion of the installation and configuration process.

## Usage

Before running the script, make sure to:

- Set the correct server hostname and server name in the Apache configuration section if needed.
- Adjust PHP configuration settings as per your requirements.
- Customize the database and user credentials as necessary.

After making these adjustments, you can execute the script to automate the setup of Piwigo on your Ubuntu server.

**Note:** This script assumes that you have a basic understanding of Linux server administration and that you are running it on a fresh Ubuntu installation. Always ensure you have proper backups and security measures in place when deploying a web application.
