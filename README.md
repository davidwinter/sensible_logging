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

### Available options

There are a number of options that you can pass into `sensible_logging`:

* `logger`: The logging object. Will default to `Logger.new(STDOUT)`
* `use_default_log_tags`: Defaults to `true`, and will include the subdomain, `RACK_ENV` and request ID in the log tags.
* `tld_length`: Defaults to `1`. For example, if your domain was `www.google.com` this would result in `www` being tagged as your subdomain. If your domain is `www.google.co.uk`, set this value to `2` to correctly identify the subdomain as `www` rather than `www.google`.
* `log_tags`: An array of additional log tags to include. This can be strings, or you can include a lamda that will be evaluated. The lambda is passed a Rack request object, and it must return an array of string values.
* `exclude_params`: An array of parameter names to be excluded from GET requests. By default, GET parameters are outputted in logs. If for example with the request `http://google.com/?one=dog&two=cat` you didn't want the `one` logged, you would set `exclude_params` to be `['one']`

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
