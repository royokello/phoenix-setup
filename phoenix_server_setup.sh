#!/bin/bash

# This script sets up an Ubuntu server for a Phoenix app.

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Error: Project name is required as the first argument."
  exit 1
fi

echo "Updating package list..."
sudo apt update

echo "Checking Erlang..."
if command -v erl > /dev/null; then
    echo "Erlang is already installed."
else
    echo "Installing Erlang..."
    sudo apt install -y erlang
fi

echo "Checking Elixir..."
if command -v elixir > /dev/null; then
    echo "Elixir is already installed."
else
    echo "Installing Elixir..."
    sudo apt install -y elixir
fi

echo "Checking Mix..."
mix local.hex --force

echo "Checking PostgreSQL..."
if dpkg -s postgresql &> /dev/null; then
    echo "PostgreSQL is already installed."
else
    echo "Installing PostgreSQL..."
    sudo apt install -y postgresql
fi

echo "Creating database user and password for $PROJECT_NAME..."
sudo -u postgres psql -c "CREATE USER $PROJECT_NAME WITH PASSWORD '$PROJECT_NAME';"

echo "Creating database for $PROJECT_NAME..."
sudo -u postgres psql -c "CREATE DATABASE $PROJECT_NAME OWNER $PROJECT_NAME;"

echo "Granting privileges to user $PROJECT_NAME on database $PROJECT_NAME..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PROJECT_NAME TO $PROJECT_NAME;"

# Optionally, inform the user about installing Node.js and npm for assets management in Phoenix
# Uncomment the lines below if you want to install Node.js and npm
# echo "Installing Node.js and npm for assets management in Phoenix..."
# sudo apt install -y nodejs npm

echo "Setup complete!"
