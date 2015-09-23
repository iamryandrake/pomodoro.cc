pomodoro.cc
============

[![Circle CI](https://circleci.com/gh/christian-fei/pomodoro.cc.svg?style=svg)](https://circleci.com/gh/christian-fei/pomodoro.cc)

# Boost your productivity
## Manage your time more effectively

[Pomodoro.cc](http://pomodoro.cc) is an online time tracking tool to plan and review the tasks for the day.

It takes advantage of the guidelines described in the [Pomodoro Technique](http://pomodorotechnique.com) to work more effectively with frequent, mind-refreshing breaks.

With the help of insightful statistics, you'll be able to better understand how much time you spent on each task and how focused you were.

-----

# Setup

```
chmod +x opt/*
opt/bootstrap
```

Fill in your information in the `credentials.json` if you want to be able to login in `http://pomodoro.dev`.
You'll need to create an app for Github and Twitter. (If you don't want to provide them, that's fine. Whilst the authentication won't work, you will still need to create this file.)

Add an entry in your `/etc/hosts`:

```
192.168.11.2    pomodoro.dev
```

Boot up the vagrant with:

```
vagrant up
```

-----

The vagrant box keep the following docker containers up and running:

- `pomodoro-main`: nginx container that routes traffic to one of the following containers
  - `pomodoro-app`: nginx container that serves the static assets
  - `pomodoro-api`: node container that represents the api
  - `pomodoro-blog`: node container that contains the blog
- `redis`: for the sessions shared between the two instances of `pomodoro-api`
- `mongo`: db for the `pomodoro-api` to save pomodori of registered users

To rebuild the infrastructure, run (from `/pomodoro.cc` inside vagrant)

- `opt/docker.restart`

or

- `opt/docker.build`
- `opt/docker.rm`
- `opt/docker.run`

##### Problems with Docker and Vagrant?

Please refer to [this issue](https://github.com/mitchellh/vagrant/issues/5748)

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

By default, `npm run e2e` runs the tests against firefox.

If you want to run the tests against Chrome, Safari and Firefox, you can use `npm run e2e-cross-browser`.

You have to install the correct chrome.webdriver and put it in `bin/`. You can download it from [here](http://chromedriver.storage.googleapis.com/index.html?path=2.16/)

You have to install the Safari webdriver extension from [here](http://selenium-release.storage.googleapis.com/index.html?path=2.45/)


#### Api

You can run the tests with: (inside vagrant)

```
/pomodoro.cc/api/opt/test
```


##### Seed The DB

```
/pomodoro.cc/opt/docker.seed
```
