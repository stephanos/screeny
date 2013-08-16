screeny
=======

Heroku-hosted screenshot server


## Getting Started

#### Create a new Heroku application.

```shell
$ heroku create --stack cedar --buildpack http://github.com/stomita/heroku-buildpack-phantomjs.git
```

#### Set secret token (for authentication)
```shell
$ heroku config:set SECRET=<mysecret>
```

#### Push repository to Heroku

#### Request screenshot

```shell
$ curl http://myscreenshotapp.heroku.com/snap?url=http://www.google.com&auth=<mysecret>&postback=http://...
```
