#!/bin/bash

# Text formatting
BOLD=$(tput bold)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 3)

# Function to print commands in bold and yellow
print_command() {
  echo -e "${BOLD}${YELLOW}$1${RESET}"
}

# Function to check and install curl if missing
install_curl() {
  if ! command -v curl &> /dev/null; then
    print_command "curl is not installed. Installing curl..."
    sudo apt update && sudo apt install curl -y || { echo "Failed to install curl. Exiting."; exit 1; }
  else
    print_command "curl is already installed."
  fi
}

# Function to install the Rivalz Node
install_node() {
    install_curl

    cd $HOME || { echo "Failed to change directory to $HOME. Exiting."; exit 1; }

    print_command "Installing NVM and Node.js..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash || { echo "Failed to download and install NVM. Exiting."; exit 1; }

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
    elif [ -s "/usr/local/share/nvm/nvm.sh" ]; then
        . "/usr/local/share/nvm/nvm.sh"
    else
        echo "Error: nvm.sh not found!"
        exit 1
    fi
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    print_command "Using Node Version Manager (nvm)..."
    nvm install node || { echo "Failed to install Node.js. Exiting."; exit 1; }
    nvm use node || { echo "Failed to use Node.js. Exiting."; exit 1; }

    print_command "Installing Rivalz CLI Package..."
    npm i -g rivalz-node-cli || { echo "Failed to install Rivalz CLI. Exiting."; exit 1; }

    print_command "Running Rivalz Node..."
    rivalz run || { echo "Failed to start Rivalz Node. Please check the logs for details."; exit 1; }

    return_to_menu
}

# Function to update the Rivalz Node
update_node() {
    print_command "Updating Rivalz CLI Package..."
    npm update -g rivalz-node-cli || { echo "Failed to update Rivalz CLI. Exiting."; return_to_menu; }
    print_command "Rivalz CLI has been updated."

    return_to_menu
}

# Function to remove the Rivalz Node
remove_node() {
    print_command "Removing Rivalz Node..."
    npm uninstall -g rivalz-node-cli || { echo "Failed to uninstall Rivalz CLI."; }
    rm -rf "$HOME/.nvm" || { echo "Failed to remove NVM directory."; }
    print_command "Rivalz Node has been removed."

    return_to_menu
}

# Function to return to the main menu
return_to_menu() {
    read -p "Press Enter to return to the main menu..."
    show_menu
}

# Display the main menu
show_menu() {
    clear
    echo "Rivalz Node Management Script"
    echo "============================"
    echo "Please choose an option:"
    echo "1) Install Rivalz Node"
    echo "2) Update Rivalz Node"
    echo "3) Remove Rivalz Node"
    echo "4) Exit"
    echo "============================"
    echo "Created by 0xHuge. Follow on Twitter at https://x.com/0xHuge"
    echo "============================"
    read -p "Enter your choice [1-4]: " choice

    case $choice in
        1)
            install_node
            ;;
        2)
            update_node
            ;;
        3)
            remove_node
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            show_menu
            ;;
    esac
}

# Run the menu function
show_menu
