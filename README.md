This project is a simple messaging app using nodejs, postgresql and reactjs

## Available Scripts

To set up, from the root directory, run ./script/setup.sh (This script will install docker, nvm and nodejs v10 as well as the node packages])

To build the docker image, run ./script/build-dev-container.sh

To run the application on your local machine, run docker and then docker-compose

## Description

This application allows real time messaging between users.

To start, simply register an account. You can then find users from the search bar by their name to send them friend requests. You and your friend can then start messaging each other after the request is accepted.

To log out, click on the ellipsis icon near the top left.

## Technology used

I use Postgres for the database and Nodejs for backend while the frontend is made with ReactJS.

Typescript was chosen over Javascript to allow the code to be more readable, although it make development a bit more time consuming

InversifyJS was used for Dependency Injection, although I did not have time to make proper unit testing.

## Architecture

![Alt text](/Pattern.jpg?raw=true "General module architectures")
Modules on NodeJS side are developed according to the MVC architecture
