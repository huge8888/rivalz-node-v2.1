# Rivalz Node Management Script

This repository provides a simple and user-friendly script to manage the installation, updating, and removal of a Rivalz Node on Ubuntu. Whether you're new to running nodes or an experienced user, this script is designed to make the process straightforward and efficient.

## Features

- **Install Rivalz Node**: Automatically installs NVM (Node Version Manager), Node.js, and the Rivalz CLI, then starts the node.
- **Update Rivalz Node**: Updates the Rivalz CLI package to the latest version.
- **Remove Rivalz Node**: Completely removes the Rivalz Node and associated files.
- **Update Proxy Settings**: Easily configure and update proxy settings if needed.

## Prerequisites

- **Operating System**: Ubuntu 20.04 or 22.04.
- **Basic Knowledge**: Familiarity with terminal commands is helpful but not required.
- **Dependencies**: The script will automatically install `curl` if it’s not already installed.

## Installation and Usage Instructions

### Step 1: Update Your Ubuntu System

After installing Ubuntu, open a terminal and update your system:

```bash
sudo apt update && sudo apt upgrade -y

### Step 2: Create the Script File:

•	Open a terminal and create the script file:

nano rivalz.sh
