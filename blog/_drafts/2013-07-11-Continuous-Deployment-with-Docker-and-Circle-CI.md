---
title:  "Continuous Deployment with Docker and CircleCI"
date:   2013-07-11
description: Setup up your own Continuous Integration with Docker and CircleCI to incrementally deliver value to your customers with Continuous Deployment.
---

After pretty much a year of [Pomodoro.cc](https://pomodoro.cc/) I'm finally confident about the [continuous integration pipeline](https://circleci.com/gh/christian-fei/pomodoro.cc) on CircleCI that I decided to try to deploy every good build to the users.
In this post I would like to go in the nitty gritty of how Pomodoro.cc does it and share some tips and tricks I understood along the way.

# The stack

[Pomodoro.cc](https://pomodoro.cc/) is composed of the following independent services:

```
NAMES                       PORTS                                      
pomodoro-main               0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   
pomodoro-app                80/tcp, 443/tcp                            
pomodoro-api                
pomodoro-blog               4000/tcp                                   
pomodoro-api-db             27017/tcp                                  
pomodoro-api-sessions       6379/tcp                                   
```

`pomodoro-main` is the main entry point of the application.
It is the only container exposed on the machine net and accessible from the outside.
It's role is to route traffic to the correct container, which leads us to the next two containers that play an essential role on pomodoro.cc:

- `pomodoro-app`
- `pomodoro-api`

Put simply: 
`pomodoro-app` contains the frontend application and `pomodoro-api` is the REST API that is consumed by the frontend application.

The `pomodoro-api` container cannot do all the session handling and database stuff all by itself, so here come into play

- `pomodoro-api-db`
- `pomodoro-api-sessions`

Both are pretty much self-explanatory: `pomodoro-api-db` contains a simple mongo instance, and `pomodoro-api-sessions` a redis that keeps track of the logged in user sessions.


