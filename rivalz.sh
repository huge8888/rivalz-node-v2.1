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

# Function to update the proxy settings and validate them
update_proxy() {
    print_command "Updating proxy settings..."
    configure_proxy
    validate_proxy
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
