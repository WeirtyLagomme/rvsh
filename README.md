# rvsh

UTT 2019 - LO14 project : linux vms manager.

## Basic usage

You either use the **connect mode** to connect to the virtual network as a normal user :

```shell
nvsh -connect <vm_name> <username>
```
Or the **admin mode** in order to access the network with some privileges :

```shell
nvsh -admin
```

In any case, you'll then have to enter your password.

## Usage

**TODO** : A compléter à chaque nouvelle commande implémentée

## System

Kepp in mind that the system will always record user's activity and keep logs of the sessions in the following directory :

```shell
./sessions/logs/<username>.logs
```

A new line of log will be added every time a user runs a command. What you can see bellow is the standard format of a line :

```shell
<username> <command> <date>
```

## More features

We added features to the initial project in order to improve it.

### Visual features
* Color support : there's now colors in rvsh to improve readability

### Architecture improvements
* User abstraction : No matter the mode, everyone should be a "user", with a username and a password.
* Every command now has a shortcut flag (-connect = -c, -admin = -a, etc...)

### New commands
* Help command (-h, --help)