# Sensible logging

A logging library with sensible defaults for Sinatra apps.

## Features

* Add (or use an existing) request ID for use in logs
* Trim the request logs to the bare minimal (method, path, status, duration and params if a GET request) - similar to lograge with Rails
* Tagged logging out of the box, with some sensible defaults; host, environment and request ID

## Usage

1. Add `sensible_logging` to your `Gemfile` and use `bundle install`.
2. In `app.rb` register the module and then define your logging defaults.

```ruby
require 'sensible_logging'

class App < Sinatra::Base
  register Sinatra::SensibleLogging

  sensible_logging(
    logger: Logger.new(STDOUT)
    )

# rest of code omitted
```

More configurations options can be found in the `examples` folder.

## Examples

There is an example Sinatra app included in this repo, so:

```shell
bundle install
cd examples
rackup
```

With the app running, run some curl commands against it:

```shell
curl 'localhost:9292/hello?one=two&two=three'
```

You should notice in the logs:

* Standard Sinatra `logger` helper works out of the box within apps with tags.
* Excluded paramaters are not included, in this example `two` based on `config.ru`
* The request log is minimal compared to out of the box Sinatra.
* `env['request_id']` is now available to hook into Sentry reports.

# License

MIT
