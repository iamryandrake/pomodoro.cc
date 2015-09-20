pomodoro.cc
============

[![Circle CI](https://circleci.com/gh/christian-fei/pomodoro.cc.svg?style=svg)](https://circleci.com/gh/christian-fei/pomodoro.cc)

# Boost your productivity
## Manage your time more effectively

[Pomodoro.cc](http://pomodoro.cc) is an online time tracking tool to plan and review the tasks for the day.

It takes advantage of the guidelines described in the [Pomodoro-technique](http://pomodorotechnique.com) to work more effectively with frequent, mind refreshing breaks.

With the help of insightful statistics, you'll be able to better understand how much you worked on each task and how concentrated you were.

-----

# Setup

```
chmod +x opt/*
opt/bootstrap
```

Fill in your information in the `credentials.json` if you want to be able to login in `http://pomodoro.dev`
You'll need to create an app for github and twitter. (If you don't want to provide them, it's fine, authentication won't work, but you need at least to create this file)

Add an entry in your `/etc/hosts`:

```
192.168.11.2    pomodoro.dev
```

Boot up the vagrant with:

```
vagrant up
```

##### [SSL certificate](https://devcenter.heroku.com/articles/ssl-certificate-self) and credentials

You can override the self-signed certificate with (put the files in the `ssl` directory) :

```
openssl genrsa -des3 -passout pass:x -out pomodoro.cc.pass.key 2048
openssl rsa -passin pass:x -in pomodoro.cc.pass.key -out pomodoro.cc.key
openssl req -new -key pomodoro.cc.key -out pomodoro.cc.csr
openssl x509 -req -days 365 -in pomodoro.cc.csr -signkey pomodoro.cc.key -out bundle.crt
```

#### App

From the `app` folder:

- to recompile the assets during development, run `npm start`

- run the tests with `npm test`

- run the end-to-end tests with `npm run e2e`

###### e2e

By default `npm run e2e` runs the tests against firefox.

If you want to run the tests against chrome safari and firefox you can use `npm run e2e-cross-browser`

You have to install the correct chrome.webdriver and put it in `bin/`. You can download it from [here](http://chromedriver.storage.googleapis.com/index.html?path=2.16/)

You have to install the safari webdriver extension from [here](http://selenium-release.storage.googleapis.com/index.html?path=2.45/)
