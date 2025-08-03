# CakeMix

A ready-to-use Docker-based development environment for [CakePHP](https://cakephp.org/).
This project includes preconfigured Docker containers that automatically install and run CakePHP on startup. It comes with a MySQL database, phpMyAdmin for database management, and DebugKit enabled for in-depth debugging during development. All services are mapped to the ./cake directory on your host machine and are configured to run as a non-root user for improved security.

## Features
- Automatic CakePHP v5 installation with DebugKit 
- Uses the Official `php:8-apache` image as a base
- incudes MySQL v8 and PHPMyAdmin

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/)

### Usage

1. Clone the repository:
```
git clone https://github.com/MichaelCaverly/CakeMix.git
cd CakeMix
```

2. Create the .env file from .env.default and populate password values
```
cp .env.default .env && \
sed -i "s|^SECURITY_SALT=\$|SECURITY_SALT=$(openssl rand -base64 60 | tr -dc 'A-Za-z0-9' | head -c60)|" .env && \
sed -i "s|^MYSQL_ROOT_PASSWORD=\$|MYSQL_ROOT_PASSWORD=$(openssl rand -base64 12 | tr -dc 'A-Za-z0-9' | head -c12)|" .env && \
sed -i "s|^MYSQL_PASSWORD=\$|MYSQL_PASSWORD=$(openssl rand -base64 12 | tr -dc 'A-Za-z0-9' | head -c12)|" .env && \
sed -i "s|^MYSQL_TEST_PASSWORD=\$|MYSQL_TEST_PASSWORD=$(openssl rand -base64 12 | tr -dc 'A-Za-z0-9' | head -c12)|" .env
```

3. Start the project
```
docker compose up
```

4. Containers are available at the following local addresses:

- CakePHP: http://127.0.0.1:3000
- PHPMyAdmin: http://127.0.0.1:3001
- MySQL accepts client connections on port 3002