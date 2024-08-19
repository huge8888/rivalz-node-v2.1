#!/bin/bash

# Text formatting
BOLD=$(tput bold)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 3)

# Define log file for proxy updates
LOG_FILE="$HOME/rivalz-proxy-update.log"

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

# Function to input and validate proxy settings
input_and_validate_proxy() {
    while true; do
        echo "Please enter your proxy details:"
        read -p "Enter your proxy server (e.g., proxy-server.com): " PROXY_SERVER
        read -p "Enter your proxy port (e.g., 8080): " PROXY_PORT
        read -p "Enter your proxy username: " PROXY_USER
        read -sp "Enter your proxy password: " PROXY_PASS
        echo

        # Export the proxy settings
        export HTTP_PROXY="http://${PROXY_USER}:${PROXY_PASS}@${PROXY_SERVER}:${PROXY_PORT}"
        export HTTPS_PROXY="https://${PROXY_USER}:${PROXY_PASS}@${PROXY_SERVER}:${PROXY_PORT}"

        # Check if the proxy is working
        print_command "Validating proxy settings..."
        if curl -x "${HTTP_PROXY}" -s https://www.google.com > /dev/null; then
            print_command "Proxy settings are working correctly."
            break
        else
            echo "Proxy validation failed. Please check your settings."
            read -p "Do you want to re-enter your proxy settings? (y/n): " retry_proxy
            if [[ "$retry_proxy" =~ ^[Nn]$ ]]; then
                echo "Exiting..."
                exit 1
            fi
        fi
    done
}

# Function to install the Rivalz Node
install_node() {
    install_curl
    input_and_validate_proxy

    cd $HOME || { echo "Failed to change directory to $HOME. Exiting."; exit 1; }

    print_command "Installing NVM and Node.js..."
    curl -x "${HTTP_PROXY}" -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash || { echo "Failed to download and install NVM. Exiting."; exit 1; }

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
