# rvsh

UTT 2019 - LO14 project : linux virtual network manager.

## Basic usage

You can either use the **connect mode** to connect to the virtual network as a normal user :

```shell
nvsh -connect <vm_name> <username>
```
Or the **admin mode** in order to access the network with some privileges :

```shell
nvsh -admin
```

For more information you can use :

```shell
nvsh -help
```

## Usage

In any mode, you can always use the following command :

```shell
help [command]
```

## System

The system will always record user's activity and keep logs in the following directory :

```shell
./usrs/<username>/logs
```

A new line of log will be added every time a user runs a command :

```shell
<date> | mode | <command>
```

## Additional features

We added features to the initial project in order to improve it.

### Visual features
* Color support : there are now colors in rvsh to improve readability

### Architecture improvements
* User abstraction : No matter the mode, everyone should be a "user", with a username and a password.
* Errors and notifications are managed globaly
* Basic tests on commands and arguments are managed trough their help content
* Messages are working in async

### New commands
* help [command]