#!/bin/bash

# Versions
REQUIRED_NODE_MAJOR_VERSION="20"
REQUIRED_NODE_MINOR_VERSION="10"
REQUIRED_PYTHON_MAJOR_VERSION="3"
REQUIRED_PYTHON_MINOR_VERSION="11"
PYTHON_COMMAND="python${REQUIRED_PYTHON_MAJOR_VERSION}.${REQUIRED_PYTHON_MINOR_VERSION}"

# Function to prompt user
prompt_user() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to compare major and minor versions
version_equals() {
    local major1=$(echo "$1" | cut -d. -f1)
    local minor1=$(echo "$1" | cut -d. -f2)
    local major2=$(echo "$2" | cut -d. -f1)
    local minor2=$(echo "$2" | cut -d. -f2)
    if [[ "$major1" == "$major2" && "$minor1" == "$minor2" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if NVM is installed
check_nvm() {
    if [ -z "$NVM_DIR" ]; then
        NVM_DIR="$HOME/.nvm"
    fi
    if [ ! -d "$NVM_DIR" ]; then
        echo "NVM is not installed. Please install NVM first."
        exit 1
    fi
    # Load NVM
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if ! command -v nvm &> /dev/null; then
        echo "NVM is not installed correctly. Please ensure NVM is installed and configured properly."
        exit 1
    fi
    echo "NVM is installed."
}

# Function to check Node.js version using NVM
check_nvm_node_version() {
    NODE_VERSION=$(nvm version | sed 's/^v//')
    REQUIRED_NODE_VERSION="$REQUIRED_NODE_MAJOR_VERSION.$REQUIRED_NODE_MINOR_VERSION"
    if ! version_equals "$NODE_VERSION" "$REQUIRED_NODE_VERSION"; then
        echo "Node.js version $REQUIRED_NODE_VERSION is not installed via NVM. Installing it now."
        nvm install $REQUIRED_NODE_VERSION
        if [ $? -ne 0 ]; then
            echo "Error installing Node.js version $REQUIRED_NODE_VERSION via NVM."
            exit 1
        fi
    fi
    echo "Using Node.js version $REQUIRED_NODE_VERSION via NVM."
    nvm use $REQUIRED_NODE_VERSION
    if [ $? -ne 0 ]; then
        echo "Error using Node.js version $REQUIRED_NODE_VERSION via NVM."
        exit 1
    fi
}

# Function to check if Python 3.11 is installed and can be used to create a virtual environment
check_python_venv() {
    PYTHON_VERSION=$($PYTHON_COMMAND --version 2>/dev/null | awk '{print $2}')
    if [ $? -ne 0 ]; then
        echo "Python $REQUIRED_PYTHON_MAJOR_VERSION.$REQUIRED_PYTHON_MINOR_VERSION is not installed or not available in PATH."
        exit 1
    fi
    REQUIRED_PYTHON_VERSION="$REQUIRED_PYTHON_MAJOR_VERSION.$REQUIRED_PYTHON_MINOR_VERSION"
    if ! version_equals "$PYTHON_VERSION" "$REQUIRED_PYTHON_VERSION"; then
        echo "Python version must be $REQUIRED_PYTHON_VERSION. Current version is $PYTHON_VERSION."
        exit 1
    fi
    echo "Python version for virtual environment is $PYTHON_VERSION."
}

# Check dependencies
check_nvm
check_nvm_node_version
check_python_venv

# Check for existing .env file
if [ -f .env ]; then
    echo ".env file already exists."
    if prompt_user "Do you want to use the existing .env file?"; then
        echo "Using existing .env file."
    else
        echo "Resetting .env file from .env.example."
        cp -RPp .env.example .env
        if [ $? -ne 0 ]; then
            echo "Error copying .env file."
            exit 1
        fi
    fi
else
    echo "No existing .env file found. Copying from .env.example."
    cp -RPp .env.example .env
    if [ $? -ne 0 ]; then
        echo "Error copying .env file."
        exit 1
    fi
fi

# Building Frontend Using Node
npm install
if [ $? -ne 0 ]; then
    echo "Error installing npm packages."
    exit 1
fi

npm run build
if [ $? -ne 0 ]; then
    echo "Error building frontend."
    exit 1
fi

# Serving Frontend with the Backend
cd ./backend
if [ $? -ne 0 ]; then
    echo "Error changing directory to ./backend."
    exit 1
fi

# Check for existing virtual environment
if [ -d venv ]; then
    echo "Virtual environment already exists."
    if prompt_user "Do you want to use the existing virtual environment?"; then
        echo "Using existing virtual environment."
        source venv/bin/activate
    else
        echo "Removing existing virtual environment and creating a new one."
        rm -rf venv
        $PYTHON_COMMAND -m venv venv
        if [ $? -ne 0 ]; then
            echo "Error creating Python virtual environment."
            exit 1
        fi
        source venv/bin/activate
        if [ $? -ne 0 ]; then
            echo "Error activating Python virtual environment."
            exit 1
        fi
    fi
else
    # Create Python virtual environment with the specified Python version
    echo "Creating a new virtual environment."
    $PYTHON_COMMAND -m venv venv
    if [ $? -ne 0 ]; then
        echo "Error creating Python virtual environment."
        exit 1
    fi
    source venv/bin/activate
    if [ $? -ne 0 ]; then
        echo "Error activating Python virtual environment."
        exit 1
    fi
fi

# Install backend requirements
pip install -r requirements.txt -U
if [ $? -ne 0 ]; then
    echo "Error installing backend requirements."
    exit 1
fi

cd ..
if [ $? -ne 0 ]; then
    echo "Error changing directory back to root."
    exit 1
fi

echo "All steps completed successfully."
