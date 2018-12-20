# Sensible logging

Proof of concept for some sensible defaults for logging in a Sinatra app.

Plan will be to wrap this up in a single self contained gem that can easily be dropped into existing Sinatra applications.

## Features

* Add (or use an existing) request ID for use in logs
* Trim the request logs to the bare minimal (method, path, status, duration and params if a GET request) - similar to lograge with Rails
* Tagged logging out of the box, with some sensible defaults; host, environment and request ID

## Demo

There is an example Sinatra app included in this repo, so:

```
bundle install
rackup
```

With the app running, run some curl commands against it:

```
curl 'localhost:9292/hello?one=two&two=three'
```

You should notice in the logs:

* Standard Sinatra `logger` helper works out of the box within apps with tags.
* Excluded paramaters are not included, in this example `two` based on `config.ru`
* The request log is minimal compared to out of the box Sinatra.
* `env['request_id']` is now available to hook into Sentry reports.

## Todo

Need to ensure `sensible_logging` confirms to all of the relevant `productionisation` checklist items. Pretty much there though.
