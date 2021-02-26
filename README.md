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

### 1. Web server architecture

#### a. Main architecture

![Alt text](/Pattern.jpg?raw=true "General module architectures")

Modules on NodeJS side are developed according to the MVC architecture. 

View is the entry point for each module that will handle parsing the request from the client side and convert the object returned from the controller side into json format. It will also need to handle the exception thrown from the controller and return the approriate error code

Controller handles the business logic.

Driver is the data access layer and communicate directly with the database (in this case Postgres) to manipulate the data according to the predefined constraints. It can also handle some checking logic to ensure data consistency

Unlike the view layer, the controller and driver may be shared between different modules for code reuse

Model is the data object that contains the data to be passed around between the layers.


Currently the application is divided into 3 different modules, each following the above architecture. When a module uses another module, it means the controller or driver of the other module is being reused on this module (currently only drivers are shared due to the code size still being simple).

The User module handles logging in, signing out, finding friends and users' info. 

The Invitation module handles sending, reject and accepting friend requests.

The Chat module handles chat creation and sending messages between users.

#### b. Middleware
- Context: generate the context object to store data from other layer such as logged in username, page limit and offset. This is needed because Typescript typing system does not allow use to arbitrarily add new property to the request object

- JwtAuthentication: generate and verify the JWT. If the authentication is successful, it will pass the logged in username to the context object.

- PaginationParams: parse the query parameters for pagination.

- UserAuthorization: Block the request if request is not yet authenticated

### 2. Database architecture

[Data modelling diagram can be viewed here] (https://dbdiagram.io/d/602f423e80d742080a3b2a65)

User and UserInfo are seperated into 2 different models to allow account deletion. If a user deletes his account, their messages should still be visible with their name and information. Thus when an account is deleted, only the User object is deleted. Seperating the 2 models also increase security since the username is not freely passed around. If a new user is created with the same username, he will be identified differently by other users since users identify each other by their info id instead of username.

