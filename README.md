screeny
=======

Heroku-hosted screenshot server


## Getting Started

1. Create a new Heroku application.

```shell
$ heroku create --stack cedar --buildpack http://github.com/stomita/heroku-buildpack-phantomjs.git
```

2. Set secret token (for authentication)
```shell
$ heroku config:set SECRET=<mysecret>
```

3. Push repository to Heroku

4. Request screenshot

```shell
$ curl http://myscreenshotapp.heroku.com/snap?url=http://www.google.com&auth=<mysecret>&postback=http://...
```
