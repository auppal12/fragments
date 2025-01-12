# fragments

## npm Setup

- Initialize npm project using npm init -y
- Install npm

## Prettier Setup

- Install Prettier: npm install --save-dev --save-exact prettier
- Configure .prettierrc for formatting preferences and .prettierignore to ignore certain files.

## ESLint Setup:

- Install ESLint using npm init @eslint/config@latest.
- Add a lint script to your package.json file to run ESLint from the command line

## Structured Logging with Pino:

- mkdir src
- Install Pino: npm install --save pino pino-pretty pino-http
- Create and configure a Pino Logger instance in src/logger.js

## Express App Setup:

- Install Express and middleware (express, cors, helmet, compression): npm install --save express cors helmet compression
- Create a src/app.js file to define our Express app

## Server Setup

- Install the stoppable package to allow graceful shutdown of the server: npm install --save stoppable
- Configure the server in src/server.js and listen on a specified port
- Install nodemon:
  - Monitors your project files and automatically restarts the server on changes
  - Saves time during development by eliminating manual server restarts
- Install jq: A command-line tool for processing JSON data
  - Useful for pretty-printing and manipulating JSON responses from APIs
  - Use it with curl to format JSON responses: curl -s localhost:8080 | jq

## Server Startup Scripts:

- Add start, dev, and debug scripts in package.json to control server behavior
- Try running the server using the following commands:
  - npm start
  - npm run dev
  - npm run debug
