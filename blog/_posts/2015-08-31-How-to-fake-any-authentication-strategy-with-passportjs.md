---
title: "How to fake any authentication strategy with Passport.js"
date: 2015-08-31
layout: post
---

Oftentimes to enable end-to-end testing with authentication you will setup a specific route to fake an authenticated user session.
Something like a route `/auth/fake`, that is of course only enabled in the development environment.

To implement this in your Node.js application, you will need:

- an fake authentication middleware
- a route to start the fake user session

Note: both the middleware and route need to be declared before any other route.

To start, let`s define what a fake user looks like:

For a social login session with Twitter or Github, the user look like this (you`ll need to change it based on your provider)

```
var fakeUser = {"id":2662706,"avatar":"https://avatars.githubusercontent.com/u/2662706?v=3","username":"christian-fei","_id":"fake"}
```

The middleware will assign the fake user to the session, while the actual route will initialize the process:

```
function middleware(req,res,next){
  if( req && req.session && req.session.user_tmp ){
    req.user = req.session.user_tmp
  }
  if( next ){
    next()
  }
}

function route(req,res){
  if( !req.session ) { req.session = {} }
  req.session.user_tmp = fakeUser
  res.redirect('/')
}
```


And now finally to tie things up, bind the functions to the middleware and route (only in development or test):

```
if( process.env.NODE_ENV==='DEV' || process.env.NODE_ENV==='test' ){
  router.use(middleware)
  router.get('/auth/fake', route)
}
```
