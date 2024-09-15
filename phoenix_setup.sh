#!/bin/bash

# This script sets up an Ubuntu server for a Rust application.

# Exit immediately if a command exits with a non-zero status
set -e

# Initialize variables with passed arguments
PROJECT_NAME=""
DB_FLAG=""

# Function to display usage
usage() {
    echo "Usage: $0 -pn <ProjectName> -db <true|false>"
    exit 1
}

# Function to handle errors
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# Function to parse input arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -pn)
                PROJECT_NAME="$2"
                shift
                shift
                ;;
            -db)
                DB_FLAG="$2"
                shift
                shift
                ;;
            *)
                echo "Unknown argument: $1"
                usage
                ;;
        esac
    done

    # Validate required arguments
    if [[ -z "$PROJECT_NAME" ]]; then
        echo "Error: Project name (-pn) is required."
        usage
    fi

    if [[ -z "$DB_FLAG" ]]; then
        echo "Error: Database flag (-db) is required."
        usage
    fi

    if [[ "$DB_FLAG" != "true" && "$DB_FLAG" != "false" ]]; then
        echo "Error: Database flag (-db) must be either 'true' or 'false'."
        usage
    fi
}

# Function to update package list
update_packages() {
    echo "Updating package list..."
    sudo apt update -y || error_exit "Failed to update package list."
}

# Function to install a package if not already installed
install_if_missing() {
    PACKAGE_NAME="$1"
    COMMAND_CHECK="$2"

    echo "Checking ${PACKAGE_NAME}..."
    if command -v $COMMAND_CHECK > /dev/null; then
        echo "${PACKAGE_NAME} is already installed."
    else
        echo "Installing ${PACKAGE_NAME}..."
        sudo apt install -y $PACKAGE_NAME || error_exit "Failed to install ${PACKAGE_NAME}."
        echo "${PACKAGE_NAME} installed successfully."
    fi
}

# Function to install PostgreSQL and configure database
setup_database() {
    echo "Setting up PostgreSQL..."

    # Check if PostgreSQL is installed
    if dpkg -s postgresql &> /dev/null; then
        echo "PostgreSQL is already installed."
    else
        echo "Installing PostgreSQL..."
        sudo apt install -y postgresql postgresql-contrib || error_exit "Failed to install PostgreSQL."
        echo "PostgreSQL installed successfully."
    fi

    # Prompt for database password
    read -s -p "Enter password for PostgreSQL user '${PROJECT_NAME}': " DB_PASSWORD
    echo
    if [[ -z "$DB_PASSWORD" ]]; then
        error_exit "Database password cannot be empty."
    fi

    # Create PostgreSQL user and database
    echo "Creating PostgreSQL user and database for '${PROJECT_NAME}'..."
    sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname = '${PROJECT_NAME}'" | grep -q 1 || sudo -u postgres psql -c "CREATE USER ${PROJECT_NAME} WITH PASSWORD '${DB_PASSWORD}';" || error_exit "Failed to create PostgreSQL user."
    sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = '${PROJECT_NAME}_db'" | grep -q 1 || sudo -u postgres psql -c "CREATE DATABASE ${PROJECT_NAME}_db OWNER ${PROJECT_NAME};" || error_exit "Failed to create PostgreSQL database."
    echo "PostgreSQL user and database for '${PROJECT_NAME}' created successfully."
}


# Main script execution
main() {
    parse_args "$@"
    update_packages
    install_if_missing "erlang" "erl"
    install_if_missing "elixir" "elixir"
    echo "Ensuring Mix is up to date..."
    mix local.hex --force || error_exit "Failed to update Hex."
    if [[ "$DB_FLAG" == "true" ]]; then
        setup_database
    else
        echo "Database setup flag is false. Skipping PostgreSQL installation."
    fi
    echo "Setup complete!"
}

main "$@"
