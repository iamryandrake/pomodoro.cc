---
title:  "The pomodoro.cc stack"
date:   2015-07-11
description: Understand how pomodoro.cc is built and how it keeps its services up and running.
---

[Pomodoro.cc](https://pomodoro.cc/) went through a lot of mutations of the stack, from a simple static web application to a solid infrastructure with docker.
In this post I would like to share how it all started and give you some info about the current stack.

# How it all started

It started all with a single page app written in AngularJS, deployed manually with a an ssh command to get the repo and build it on a [DigitalOcean droplet](https://www.digitalocean.com/?refcode=880e8f681b50).

It was definitely good enough. The process was streamlined, simple and efficient. Error-prone? Not so much, the script took care of it.

Things started to grow, new ideas came up. First the API, then the login and session management.

A Continuous Integration was needed, and one on [CircleCI](https://circleci.com/) has been set up and the deployment was automatic and reliable.



# The stack

Eventually docker became very interesting to build the infrastructure and keep it up and running.



[Pomodoro.cc](https://pomodoro.cc/) is composed of the following services, here the `docker ps` output:

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



---

If you are interested, here is the [Github repository](https://github.com/christian-fei/pomodoro.cc) to try it yourself.

Of course contributions are *very* welcome :)
