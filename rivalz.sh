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

# Function to prompt for proxy details and update settings
configure_proxy() {
    echo "Current proxy settings:"
    echo "HTTP_PROXY=${HTTP_PROXY}"
    echo "HTTPS_PROXY=${HTTPS_PROXY}"
    echo
    read -p "Do you want to update the proxy settings? (y/n): " use_proxy
    if [[ "$use_proxy" =~ ^[Yy]$ ]]; then
        read -p "Enter your proxy username: " PROXY_USER
        read -sp "Enter your proxy password: " PROXY_PASS
        echo
        read -p "Enter your proxy server (e.g., proxy-server.com): " PROXY_SERVER
        read -p "Enter your proxy port (e.g., 8080): " PROXY_PORT

        # Export the proxy settings
        export HTTP_PROXY="http://${PROXY_USER}:${PROXY_PASS}@${PROXY_SERVER}:${PROXY_PORT}"
        export HTTPS_PROXY="https://${PROXY_USER}:${PROXY_PASS}@${PROXY_SERVER}:${PROXY_PORT}"
        npm config set proxy "${HTTP_PROXY}"
        npm config set https-proxy "${HTTPS_PROXY}"

        # Log the update
        echo "$(date): Updated proxy to ${HTTP_PROXY}" >> "$LOG_FILE"
        print_command "Proxy settings updated."
    else
        print_command "No changes made to proxy settings."
    fi
}

# Function to validate proxy settings
validate_proxy() {
    print_command "Validating proxy settings..."
    if curl -x "${HTTP_PROXY}" -s https://www.google.com > /dev/null; then
        print_command "Proxy settings are working correctly."
    else
        echo "Proxy validation failed. Please check your settings."
        echo "$(date): Proxy validation failed for ${HTTP_PROXY}" >> "$LOG_FILE"
        retry_proxy_update
    fi
}

# Function to retry or revert proxy settings if validation fails
retry_proxy_update() {
    echo "Proxy validation failed. What would you like to do next?"
    echo "1) Retry validation"
    echo "2) Re-enter proxy settings"
    echo "3) Revert to previous proxy settings"
    echo "4) Skip validation"
    read -p "Enter your choice [1-4]: " choice

    case $choice in
        1)
            validate_proxy
            ;;
        2)
            configure_proxy
            validate_proxy
            ;;
        3)
            revert_proxy_settings
            validate_proxy
            ;;
        4)
            echo "Skipping validation."
            ;;
        *)
            echo "Invalid option. Returning to main menu."
            return_to_menu
            ;;
    esac
}

# Function to revert to previous proxy settings
revert_proxy_settings() {
    print_command "Reverting to previous proxy settings..."
    # Implement logic to restore previous proxy settings if needed
    # For now, just notify the user
    echo "Reverting is not implemented in this example."
    echo "$(date): Attempted to revert proxy settings" >> "$LOG_FILE"
}

# Function to install the Rivalz Node
install_node() {
    configure_proxy

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

# Function to update the proxy settings and validate them
update_proxy() {
    print_command "Updating proxy settings..."
    configure_proxy
    validate_proxy
    return_to_menu
}

# Function to view logs
view_logs() {
    print_command "Displaying logs..."
    if [ -f "/var/log/rivalz-node.log" ]; then
        tail -f /var/log/rivalz-node.log
    else
        echo "Log file not found. Ensure that the Rivalz Node is running."
    fi

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

# Function to create a backup
backup_node() {
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/rivalz-backup-$(date +%F-%T).tar.gz"
    print_command "Creating backup..."
    tar -czvf "$BACKUP_FILE" "$DATA_DIR" "$CONFIG_FILE" || { echo "Failed to create backup."; return_to_menu; }
    print_command "Backup created at $BACKUP_FILE."

    return_to_menu
}

# Function to restore a backup
restore_node() {
    read -p "Enter the path to the backup file: " BACKUP_FILE
    if [ -f "$BACKUP_FILE" ]; then
        print_command "Restoring from backup..."
        tar -xzvf "$BACKUP_FILE" -C / || { echo "Failed to restore from backup."; return_to_menu; }
        print_command "Backup restored successfully."
    else
        echo "Backup file not found."
    fi

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
    echo "2) View Rivalz Node Logs"
    echo "3) Remove Rivalz Node"
    echo "4) Backup Rivalz Node"
    echo "5) Restore Rivalz Node"
    echo "6) Update Rivalz Node"
    echo "7) Update Proxy Settings"
    echo "8) Exit"
    echo "============================"
    read -p "Enter your choice [1-8]: " choice

    case $choice in
        1)
            install_node
            ;;
        2)
            view_logs
            ;;
        3)
            remove_node
            ;;
        4)
            backup_node
            ;;
        5)
            restore_node
            ;;
        6)
            update_node
            ;;
        7)
            update_proxy
            ;;
        8)
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
