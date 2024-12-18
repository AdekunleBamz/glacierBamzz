#!/bin/bash

# ----------------------------
# Colors and Icons Definitions
# ----------------------------
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No color

CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="📦"
SUCCESS="🎉"
WARNING="⚠️"
NODE="🖥️"
INFO="ℹ️"

# Icons for the header
ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_DELETE="🗑️"
ICON_UPDATE="🔄"
ICON_LOGS="📄"
ICON_CONFIG="⚙️"
ICON_EXIT="🚪"

# ----------------------------
# ASCII Art Header
# ----------------------------
display_ascii() {
    echo -e "    ${RED}___          __  __ ____________${RESET}"
    echo -e "    ${GREEN}|  _ \   /\   |  \/  |___  |___  /${RESET}"
    echo -e "    ${BLUE}| |_) | /  \  | \  / |  / /   / / ${RESET}"
    echo -e "    ${CYAN}|  _ < / /\ \ | |\/| | / /   / /  ${RESET}"
    echo -e "    ${MAGENTA}| |_) / ____ \| |  | |/ /__ / /__ ${RESET}"
    echo -e "    ${YELLOW}|____/_/    \_|_|  |_/_____/_____|${RESET}"
    echo -e "    ${YELLOW}📢 Follow us on Twitter: https://x.com/HRH_Mckay${RESET}"
}

# ----------------------------
# Menu Borders
# ----------------------------
draw_top_border() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"

}

draw_middle_border() {

    echo -e "${BLUE}╠══════════════════════════════════════════════════════╣${NC}"
}

draw_bottom_border() {
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    
}

# ----------------------------
# Main Menu Function
# ----------------------------
main_menu() {
    while true; do
        display_ascii
        draw_top_border
        echo -e "  ${SUCCESS}  ${GREEN}Welcome to the Glacier Node Installation Wizard!${NC}"
        draw_middle_border
        echo -e "${CYAN}  1) Install and Start the Node ${ICON_INSTALL}${NC}"
        echo -e "${CYAN}  2) Stop the Node ${ICON_DELETE}${NC}"
        echo -e "${CYAN}  3) View Logs ${ICON_LOGS}${NC}"
        echo -e "${CYAN}  4) Exit ${ICON_EXIT}${NC}"
        draw_bottom_border
        read -p "Choose an option: " action

        case $action in
            1)
                install_docker
                create_env_file
                start_node
                read -p "Press Enter to return to the main menu..." ;;
            2)
                stop_node
                read -p "Press Enter to return to the main menu..." ;;
            3)
                view_logs
                read -p "Press Enter to return to the main menu..." ;;
            4)
                echo "Exiting the program..."
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice. Please try again.${NC}"
                read -p "Press Enter to return to the main menu..." ;;
        esac
    done
}

# Function to install Docker and Docker Compose
install_docker() {
    echo "Checking for Docker..."
    if ! command -v docker &> /dev/null; then
        echo "Docker not found. Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        echo "Docker installed."
    else
        echo "Docker is already installed."
    fi

    echo "Checking for Docker Compose..."
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose not found. Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose installed."
    else
        echo "Docker Compose is already installed."
    fi
}

# Function to create the .env file
create_env_file() {
    read -p "Enter your PRIVATE_KEY: " private_key
    echo "PRIVATE_KEY=$private_key" > .env
    echo ".env file created."
}

# Function to start the node
start_node() {
    echo "Starting the node..."
    docker-compose up -d
    if [ $? -eq 0 ]; then
        echo "Node successfully installed and started."
    else
        echo "Error while starting the node."
    fi
}

# Function to stop the node
stop_node() {
    echo "Stopping the node..."
    docker-compose down
    if [ $? -eq 0 ]; then
        echo "Node successfully stopped."
    else
        echo "Error while stopping the node."
    fi
}

# Function to view logs
view_logs() {
    echo "Viewing the last 50 logs..."
    docker-compose logs --tail=50
}

# Execute Main Menu
main_menu
