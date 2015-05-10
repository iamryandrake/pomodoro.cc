pomodoro garden
==============


# setup

## development host

Add an entry in your `/etc/hosts`:

```
192.168.11.2    pomodoro.dev
```

Execute

```
make bootstrap
vagrant up
```

It will download and resolve dependencies of the following services [follow the readme of each one] and put them in the `services` folder

- [pomodoro](https://github.com/christian-fei/pomodoro)
- [pomodoro-api](https://github.com/christian-fei/pomodoro-api)

