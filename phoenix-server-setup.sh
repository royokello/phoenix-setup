#!/bin/bash

# This script sets up an Ubuntu server for a Phoenix app.

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

echo "Checking Postgres..."
if dpkg -s postgresql &> /dev/null; then
    echo "PostgreSQL is already installed."
else
    echo "Installing PostgreSQL..."
    sudo apt install -y postgresql postgresql-contrib
    
    postgres_password="postgres"
    echo "Setting a predefined password for the PostgreSQL user 'postgres'..."
    sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD '$postgres_password';"
fi

# Check if the 'phoenix' database exists
if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw phoenix; then
    echo "The 'phoenix' database already exists."
else
    echo "Creating a PostgreSQL database named 'phoenix'..."
    sudo -u postgres createdb phoenix
fi

echo "Installed versions:"
echo "Erlang $(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell)"
echo "Elixir $(elixir --version)"
echo "PostgreSQL $(psql --version)"

# Optionally, inform the user about installing Node.js and npm for assets management in Phoenix
# Uncomment the line below if you want to install Node.js and npm
# echo "Installing Node.js and npm for assets management in Phoenix..."
# sudo apt install -y nodejs npm

echo "Setup complete!"
