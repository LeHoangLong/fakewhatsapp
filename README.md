This project is a simple messaging app using nodejs, postgresql and reactjs.
## Available Scripts

To set up, from the root directory, run ./script/setup.sh (This script will install docker, nvm and nodejs v10 as well as the node packages])

To build the docker image, run ./script/build-dev-container.sh

To run the application on your local machine, run docker and then docker-compose

## Description

This application allows real time messaging between users.

To start, simply register an account. You can then find users from the search bar by their name to send them friend requests. You and your friend can then start messaging each other after the request is accepted.

To log out, click on the ellipsis icon near the top left.

For live demo, simply go to http://35.198.195.103/ and sign up with your username. Or you can try out some precreated accounts:
| Username | Password |
|----------|----------|
|abc|123|
|abcd|1234|
|abcde|12345|

Usage demo

![Alt text](/docs/login.gif?raw=true "Log in demo")

![Alt text](/docs/sendmessage.gif?raw=true "send message demo")

![Alt text](/docs/logout.gif?raw=true "Log outdemo")

## Technology used

I use Postgres for the database and Nodejs for backend while the frontend is made with ReactJS.

Typescript was chosen over Javascript to allow the code to be more readable, although it make development a bit more time consuming

InversifyJS was used for Dependency Injection, although I did not have time to make proper unit testing.

## Architecture

### 1. Web server architecture

#### a. Main architecture

![Alt text](/docs/Pattern.jpg?raw=true "General module architectures")

Modules on NodeJS side are developed according to the MVC architecture. 

View is the entry point for each module that will handle parsing the request from the client side and convert the object returned from the controller side into json format. It will also need to handle the exception thrown from the controller and return the approriate error code

Controller handles the business logic.

Driver is the data access layer and communicate directly with the database (in this case Postgres) to manipulate the data according to the predefined constraints. It can also handle some checking logic to ensure data consistency

Unlike the view layer, the controller and driver may be shared between different modules for code reuse

Model is the data object that contains the data to be passed around between the layers.

![Alt text](/docs/MainPackages.jpg?raw=true "Main web server packages")

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

![Alt text](/docs/DatabaseModels.png?raw=true "Database models")

Data modelling diagram can be viewed here (https://dbdiagram.io/d/602f423e80d742080a3b2a65)

User and UserInfo are seperated into 2 different models to allow account deletion. If a user deletes his account, their messages should still be visible with their name and information. Thus when an account is deleted, only the User object is deleted. Seperating the 2 models also increase security since the username is not freely passed around. If a new user is created with the same username, he will be identified differently by other users since users identify each other by their info id instead of username.

### 3. Front end architecture

#### a. General architecture

![Alt text](/docs/Redux.jpg?raw=true "Front end redux architecture")

The front end side follow the general Redux architecture, with one additional controller layer. This controller layer is tightly couple with the Widget and is responsible for handling events / state changes. The reason for this additional controller layer is to seperate the display logic and control logic and makes the code cleaner. The downside is that the project structure is a bit more complex (more files) and thus harder to navigate around the code.

The dispatcher handles communication with the backend and then dispatch the action to the reducers. IoC is used here to allow abstraction of data access, and thus we can use local storage in the future should that be needed.

#### b. Widget tree

![Alt text](/docs/WidgetTree.jpg?raw=true "Widget tree")

- App: entry point of the application. It determines whether to show LoginPage or MainPage depending on whether user is logged in or not.

- LoginPage: Login or sign up page

- MainPage: The page to show after user has succesfully logged in. Consist of SideBar on the left and the remaining space is given to ConversationView or StrangerView. ConversationView and StrangerView overlaps each other and thus only 1 of them can be shown at any time, depending on whether the selected user is friend or if a chat is selected.

- SideBar: Determine whether to show FriendBar or ChatBar based on whether the user has any entered any value in the SearchBar. If there is no chat for the logged in user (newly signed up user), the FriendBar will also show up instead of the ChatBar

- ChatBar: Show the most recent chats. It will periodically fetch the chats so that if a friend sends a message, the user will immediately be notified.

- FriendBar: Show the list of friends based on the search criteria. Will also show strangers So that user can add new friend.

- ConversationView: Show the messages between 2 users. It will periodically fetch the messages from the other user.

- StrangerView: Show the general information of the user and allow user to send / accept / reject friend requests.

#### c. State tree

![Alt text](/docs/StateTree.jpg?raw=true "State tree")

- AppState: container for all the state of the app

- UserState: current user information and whether they are logged in

- FriendState: holds list of friends

- FoundUserState: holds list of users obtained from search result so that subsequent search result will be displayed faster

- ChatState: Holds the conversations, and the selected chat / user.

- OperationStatusState: holds the status of the CRUD operation when performing communication with backend side. Currently there are 5 possible states: INIT, IN_PROGRESS, SUCCESS, ERROR, IDLE. For each different CRUD operation such as fetch user info, there is a corresponding operation status. This operation status is used by the Widget to determine whether to show loading icon or by the controller to perform some initilization action such as fetching user information.

- InvitationState: holds the invitations recieved from and sent to other users.