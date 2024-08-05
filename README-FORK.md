# Open WebUI - Custom Fork

This repo is all tested on macOS. For other environments, you may need to adjust the instructions. 

## Dependencies

You'll need to have the following:
1. Node Version Manager (NVM) with NodeJS v20.10 installed under NVM.
2. Python 3.11 installed with Homebrew or another package manager.
3. Access to the Internet so that you can install the dependencies (NPM for NodeJS and PIP for Python).

## First Build

1. Clone the repository
2. Copy `.env.example` to `.env` and update any values supported by Open WebUI, including OpenAI API Key if you have one that you want to set for the entire instance.
3. From the root of the repository, run `_local_build.sh` to build the project. This will install all dependencies and build the project. This takes a while, so be patient.
4. If the build finishes without errors, you can run `_local_start.sh` to start the backend and frontend. Watch the console for the URLs to access the frontend once it starts.
5. On the very first build, you'll create an ADMIN USER. Keep track of this user since you'll need it to log in and manage the instance.

