#!/bin/bash

set -e

APP_DIR="/var/www/html"
TEMP_DIR="/tmp/cake"
CAKE_CORE_FILE="$APP_DIR/cake/bin/cake"

# Function to install CakePHP
install_cakephp() {
  echo "CakePHP not found."

  echo "Emptying the temp dir..."
  rm -rf $TEMP_DIR

  echo "Installing CakePHP to temp dir..."
  composer create-project --prefer-dist cakephp/app "$TEMP_DIR"

  echo "Copying files from temp dir to html root"
  cp -r $TEMP_DIR $APP_DIR

  echo "Writing config/app_local.php"
  cp -r app_local.php $APP_DIR/cake/config/

  echo "Make bin/cake executable" 
  chmod +x $CAKE_CORE_FILE

  echo "CakePHP installation complete."
}

# Check if CakePHP is already installed
if [ ! -f "$CAKE_CORE_FILE" ]; then
  install_cakephp
else
  echo "CakePHP is already installed."
fi

# Wait for MySQL
until mysql --host="$MYSQL_HOST" \
            --port="$MYSQL_PORT" \
            --user="$MYSQL_USERNAME" \
            --password="$MYSQL_PASSWORD" \
            --silent --skip-column-names \
            -e "SELECT 1;" &>/dev/null; do
  echo "MySQL is unavailable - sleeping"
  sleep 2
done

# make the migrations directory to avoid a migrations error
mkdir -p $APP_DIR/cake/config/Migrations

# Run Migrations
$CAKE_CORE_FILE migrations migrate

# Clear Caches  
$CAKE_CORE_FILE cache clear_all

# Run the main container process (from the Dockerfile CMD for example)
exec "$@"
