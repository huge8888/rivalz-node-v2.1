# rivalz-node-v2.1
# Rivalz Node Management Script

This repository provides an easy-to-use script for installing, updating, backing up, restoring, and managing your Rivalz Node on an Ubuntu 20.04 or 22.04 server. The script is designed with a user-friendly interactive menu, making it accessible even for those with minimal experience.

## Features

- **Interactive Menu**: Install, update, backup, restore, and manage your Rivalz Node through a simple menu.
- **Optional Proxy Configuration**: Easily configure and update proxy settings as needed.
- **Automatic Validation**: Validate proxy settings in real-time with feedback and options to retry or revert if necessary.
- **Backup and Restore**: Create backups of your node’s data and configuration, and restore them if needed.
- **Update Node**: Keep your Rivalz Node CLI up to date with the latest features and fixes.
- **Error Handling and Logging**: Robust error handling with logs for troubleshooting proxy issues.

## Prerequisites

- **Operating System**: Ubuntu 20.04 or 22.04.
- **Basic Knowledge**: Familiarity with terminal commands is helpful but not required.
- **Optional**: Proxy server details if your environment requires proxy usage.

## Installation Instructions

### 1. Prepare Your Ubuntu Server

Ensure your server is up to date:

```bash
sudo apt update && sudo apt upgrade -y

Run the Script

Execute the script with:
./rivalz.sh
