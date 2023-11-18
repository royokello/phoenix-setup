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
fi

# Check if the "root" user is in postgres, if not add one with the password "postgres"
if sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='root'" | grep -q 1; then
    echo "User 'root' already exists in PostgreSQL."
else
    echo "Adding 'root' user to PostgreSQL..."
    sudo -u postgres psql -c "CREATE USER root WITH PASSWORD 'postgres';"
    sudo -u postgres psql -c "ALTER USER root WITH SUPERUSER;"
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
