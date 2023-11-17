# Phoenix Server Setup

This script automates the setup process for an Ubuntu server to run a Phoenix web application. It installs Erlang, Elixir, PostgreSQL, and optionally Node.js and npm. The script also sets up the PostgreSQL user for your Phoenix app.

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/royokello/phoenix-server-setup.git
    cd phoenix-server-setup
    ```

2. Make the script executable:

    ```bash
    chmod +x phoenix-server-setup.sh
    ```

3. Run the script:

    ```bash
    ./phoenix-server-setup.sh
    ```

4. Follow the prompts to set the PostgreSQL user password.

5. Verify the installed versions and configurations.

## Important Note

- This script sets a predefined password for the PostgreSQL user `postgres` for simplicity. Ensure that the password is strong and secure.

## Optional Dependencies

- Node.js and npm are optionally installed for managing assets in Phoenix apps.

## License

This script is provided under the [MIT License](LICENSE).
