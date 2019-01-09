# Sensible logging

A logging library with sensible defaults for Sinatra apps.

## Features

* Add (or use an existing if present `X-Request-Id`) request ID for use in logs
* Trim the request logs to the bare minimal (inspired by lograge):
  * method
  * path
  * requesting IP address
  * status
  * duration
  * params if a `GET` request
* Tagged logging, with some sensible defaults:
  * subdomain
  * environment
  * unique request ID

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

* `logger`: The logging object.  
  **Default**: `Logger.new(STDOUT)`
* `use_default_log_tags`: Includes the subdomain, `RACK_ENV` and unique request ID in the log tags.  
  **Default**: `true` 
* `tld_length`: For example, if your domain was `www.google.com` this would result in `www` being tagged as your subdomain. If your domain is `www.google.co.uk`, set this value to `2` to correctly identify the subdomain as `www` rather than `www.google`.  
  **Default**: `1`.
* `log_tags`: An array of additional log tags to include. This can be strings, or you can include a `lamda` that will be evaluated. The `lambda` is passed a Rack `Request` object, and it must return an array of string values.  
  **Default**: `[]`
* `exclude_params`: An array of parameter names to be excluded from `GET` requests. By default, `GET` parameters are outputted in logs. If for example with the request `http://google.com/?one=dog&two=cat` you didn't want the `one` logged, you would set `exclude_params` to be `['one']`  
  **Default**: `[]`

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
