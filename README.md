# fragments

## npm Setup

- Initialize npm project using npm init -y

## Prettier Setup

- Install Prettier: npm install --save-dev --save-exact prettier
- Configure .prettierrc for formatting preferences and .prettierignore to ignore certain files.

## ESLint Setup:

- Install ESLint using npm init @eslint/config@latest.

## Structured Logging with Pino:

- Install Pino: npm install --save pino pino-pretty pino-http.

## Express App Setup:

- Install Express and middleware (express, cors, helmet, compression).

## Server Setup with Graceful Shutdown:

- Install the stoppable package to allow graceful shutdown of the server.
- Configure the server in src/server.js and listen on a specified port.

## Server Startup Scripts:

- nodemon as a dev dependency to automatically restart the server on changes: npm install --save-dev nodemon.
- Add start, dev, and debug scripts in package.json to control server behavior.
- Try running the server using the following commands:
  - npm start
  - npm run dev
  - npm run debug
