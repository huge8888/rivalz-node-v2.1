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

### 2. Install Git (If Not Already Installed)

Git is required to clone your GitHub repository:
sudo apt install git -y

3. Clone the Repository

Clone the repository from GitHub using the following command:
git clone https://github.com/huge8888/rivalz-node-v2.1.git

4. Navigate to the Repository Directory

Change to the directory where the script is located:
cd rivalz-node-v2.1

5. Make the Script Executable
chmod +x rivalz.sh

6. Run the Script

Execute the script:

./rivalz.sh

7. Follow the On-Screen Prompts

The script will guide you through the following options:

	•	1) Install Rivalz Node: Install NVM (Node Version Manager), Node.js, and the Rivalz Node CLI. If needed, configure a proxy.
	•	2) View Rivalz Node Logs: Display real-time logs to monitor the node’s activity.
	•	3) Remove Rivalz Node: Completely uninstall the Rivalz Node and remove related files.
	•	4) Backup Rivalz Node: Create a backup of the node’s data and configuration.
	•	5) Restore Rivalz Node: Restore from a previous backup.
	•	6) Update Rivalz Node: Update the Rivalz CLI to the latest version.
	•	7) Update Proxy Settings: Modify proxy settings and validate them immediately.
	•	8) Exit: Exit the script.
