#!/bin/bash

# This script sets up an Ubuntu server for a Phoenix app.

echo "Updating package list..."
sudo apt update

echo "Installing Erlang..."
sudo apt install -y esl-erlang

echo "Installing Elixir..."
sudo apt install -y elixir

echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

postgres_password="postgres"
echo "Setting a predefined password for the PostgreSQL user 'postgres'..."
sudo -u postgres psql -c "alter user postgres with encrypted password '$postgres_password';"

echo "Installed versions:"
echo "Erlang $(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell)"
echo "Elixir $(elixir --version)"
echo "PostgreSQL $(psql --version)"

# Optionally, inform the user about installing Node.js and npm for assets management in Phoenix
# Uncomment the line below if you want to install Node.js and npm
# echo "Installing Node.js and npm for assets management in Phoenix..."
# sudo apt install -y nodejs npm

echo "Setup complete!"
