# install_rss_service.sh - Systemd Service Setup Script

## Description
`install_rss_service.sh` is a shell script that simplifies the process of setting up a systemd service on a Linux system. It automates the creation of a systemd service unit, downloads a Python script from a specified GitHub repository, and configures the service to run the Python script at regular intervals (every 60 seconds). This script is especially useful for automating tasks and background processes that need to be executed periodically.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [License](#license)

## Prerequisites
- This script is intended for use on a Linux system with `systemd` installed.
- You should have `git` installed to clone the required GitHub repository.

## Installation
1. Clone this repository or download the `install_rss_service.sh` script.
2. Make the script executable:
   ```shell
   chmod +x install_rss_service.sh
   ```

## Configuration
Before running the script, you need to configure it by editing the `config.ini` file. The configuration file contains the following variables:

- `WEBHOOK_URL`: (Optional) URL for a webhook (if applicable).
- `RSS_FEED_URL`: (Optional) URL for an RSS feed (if applicable).
- `PYTHON_SCRIPT_PATH`: Path to the Python script you want to run.
- `USERNAME`: The username under which the service will run.
- `DIRECTORY_PATH`: The directory where the Python script and configuration files will be stored.
- `SERVICE_DESCRIPTION`: Description of the systemd service.
- `SERVICE_FILE_NAME`: Name of the systemd service unit file.
- `GITHUB_REPO`: (Optional) URL of the GitHub repository to download the Python script from. Leave empty if not needed.

## Usage
1. Configure the `config.ini` file as mentioned in the Configuration section.
2. Run the script with the following command:
   ```shell
   ./install_rss_service.sh
   ```
3. The script will set up the systemd service, download the Python script (if `GITHUB_REPO` is specified), and configure it to run every 60 seconds.
4. Start and enable the service using:
   ```shell
   systemctl start [SERVICE_NAME]
   systemctl enable [SERVICE_NAME]
   ```

## License
This project is licensed under the [MIT License](LICENSE).

---


