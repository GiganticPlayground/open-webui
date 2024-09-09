# Open WebUI - Custom Fork - OpenAI Focused

This is a fork of the Open WebUI project that is focused on integrating OpenAI's APIs and excludes Ollama. 

This fork is not affiliated with OpenAI.

This repo is all tested on macOS. For other environments, you may need to adjust the instructions.

## General Dependencies

1. You'll need an OpenAI API Key. You can get one by signing up at https://beta.openai.com/signup/.

##  Self-Signed Certificate Generation for Development

Refer to the [Self-Signed Certificate Generation](_dev_tools/TLS/README.md) section for generating self-signed certificates for development.

## Running Natively

This section discusses how to build and run the Open WebUI project natively on your machine. This is useful for development and testing purposes.

### Dependencies

You'll need to have the following:
1. Node Version Manager (NVM) with NodeJS v20.10 installed under NVM.
2. Python 3.11 installed with Homebrew or another package manager.
3. Access to the Internet so that you can install the dependencies (NPM for NodeJS and PIP for Python).

### First Build and Run

1. Clone the repository
2. Copy `example-environment-openai-focused.env` to `.env` and update any values supported by Open WebUI, including OpenAI API Key if you have one that you want to set for the entire instance.
3. From the root of the repository, run `x-native-build.sh` to build the project. This will install all dependencies and build the project. This takes a while, so be patient.
4. If the build finishes without errors, you can run `x-native-start.sh` to start the backend and frontend. Watch the console for the URLs to access the frontend once it starts.
5. On the very first build, you'll create an ADMIN USER. Keep track of this user since you'll need it to log in and manage the instance.

## Running in Docker

This section discusses how to run the Open WebUI project in Docker. This is useful for deploying the project in a containerized environment.

### Dependencies

You'll need to have the following:
1. Docker installed on your machine.
2. Docker Compose installed on your machine.
3. Access to the Internet so that you can pull the Docker images.

### First Build and Run

1. Clone the repository
2. Copy `example-environment-openai-focused.env` to `.env` and update any values supported by Open WebUI, including OpenAI API Key if you have one that you want to set for the entire instance.
3. From the root of the repository, run `x-docker-custom1-build.sh` to build the Docker images. This will build the backend and frontend images. This takes a while, so be patient.
4. If the build finishes without errors, you can run `x-docker-custom1-up.sh` to start the backend and frontend. Watch the console for the URLs to access the frontend once it starts.
5. On the very first build, you'll create an ADMIN USER. Keep track of this user since you'll need it to log in and manage the instance.
6. To stop the containers, run `x-docker-custom1-down.sh`.
7. To clear out all data and start fresh, run `x-docker-custom1-down.sh --volumes` to wipe out the volumes. Note, you'll have to create your admin user again!

Note that in each of the above scripts (build, up, down) they use standard docker compose build, up and down and so you can pass extra arguments of your choice.

