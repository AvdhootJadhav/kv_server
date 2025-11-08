# KvServer

A simple application which demonstrate the concept of GenServer and Supervisor in Elixir. When the application starts, it spawns following components as individual process -
  
  - Task Supervisor - Handles each connection to http server separately allowing multiple client connections
  - DB GenServer - Manages the in-memory CRUD operations
  - Http Server - Started as separate process which listens to user defined port and serves the request

This application allows the users to Create and manage multiple shopping lists. User can interact with their lists using below commands -

  - `CREATE <list-name>` - Creates a list of the user
  - `GET <list>` - Pulls the list by name and display it to user
  - `PUT <list-name> <item-name> <qty>` - updates the list with item and desired qty
  - `DELETE <list-name>` - Deletes the entire list
  - `DELETE <list-name> <item>` - Deletes the specified item from the list

## Steps to run

- Clone the repository and open a terminal and navigate to project directory
- Run `PORT=<port-number> mix run --no-halt` command from your terminal
- This will start the application and all of the above process would be started which is evident through logs
- Now, open another terminal and telnet to the port which is used by your project
- You would be connected to the server and can manage your shopping lists
- Use above commands to interact with your lists
