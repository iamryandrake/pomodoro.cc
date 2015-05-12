pomodoro.cc

==============

# Boost your productivity
## Manage your time more effectively

[Pomodoro.cc](http://pomodoro.cc) is an online time tracking tool to plan and review the tasks for the day.

It takes advantage of the guidelines described in the [Pomodoro-technique](http://pomodorotechnique.com) to work more effectively with frequent, mind refreshing breaks.

With the help of insightful statistics you'll be able to better understand how much you worked on each task and how concentrated you were.

-----

# Setup

## Vagrant

Setup a `credentials.json` starting from `credentials.template.json` and fill in your information.
You'll need to create an app for github and twitter. (If you don't want to provide them, it's fine, authentication won't work, but you need at least to create this file)

Add an entry in your `/etc/hosts`:

```
192.168.11.2    pomodoro.dev
```

Execute

```
make bootstrap
vagrant up
```


### Development

The vagrant box keep the following docker containers up and running:

- `pomodoro`: the frontend with nginx and angular
- `pomodoro-api`: the api with node, redis, and mongodb

Note: `pomodoro` proxies the requests that match the api to the api container


#### App

From the `app` folder:

- to recompile the assets during development, run `gulp watch`

- run the tests with `npm test`

- run the end-to-end tests with `make i_web_driver` (once) and `npm run e2e-test`

#### Api

You can run the tests with: ...
