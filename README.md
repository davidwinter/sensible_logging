# Sensible Logging

[![CircleCI](https://circleci.com/gh/madetech/sensible_logging.svg?style=svg)](https://circleci.com/gh/madetech/sensible_logging)
[![codecov](https://codecov.io/gh/madetech/sensible_logging/branch/master/graph/badge.svg)](https://codecov.io/gh/madetech/sensible_logging)
[![Gem Version](https://badge.fury.io/rb/sensible_logging.png)](http://badge.fury.io/rb/sensible_logging)

A logging extension with sensible defaults for Sinatra apps.

## Features

* Add a request UUID (or use an existing one if present in the `X-Request-Id` HTTP header) for use in logs, your app or other middlewares
* Trim the request logs to the bare minimal (inspired by lograge):
  * method
  * path
  * requesting IP address
  * status
  * duration
  * params if a `GET` request

  Example log line:
  ```
  method=GET path=/contact client=192.168.1.254 status=200 duration=0.124 params={"category"=>"question"}
  ```
* Tagged logging, with some sensible defaults:
  * severity
  * subdomain
  * environment
  * request UUID

  Example log line:
  ```
  [INFO] [www.gb] [staging] [6004bb70-7b6d-43b6-a2cf-72d0336663ba] @todo tidy sql query
  ```

## Usage

1. Add `sensible_logging` to your `Gemfile` and install with `bundle install`:

  ```ruby
  gem 'sensible_logging'
  ```
2. In your `app.rb` register the module and then define your logging configuration:

  ```ruby
  require 'sensible_logging'

  class App < Sinatra::Base
    register Sinatra::SensibleLogging

    # Initialise Sensible Logging to add our middlewares.
    sensible_logging(
      logger: Logger.new(STDOUT)
      )

    # Configure the log level for different environments
    configure :production do
      set :log_level, Logger::INFO
    end

    # Requests will be logged in a minimal format
    get '/' do
      'Hello!'
    end

    get '/about' do
      # The standard Sinatra logger helper will use the Sensible Logging gem
      logger.info('About page')
    end

    get '/contact' do
      # In addition to the default tags, you can add additional ones by using the `tagged` block on the `logger` helper
      # [INFO] [localhost] [development] [a9d0183d-a3c3-4081-b502-38dcf4c3c4d7] [todo] Contact page
      logger.tagged('todo') do |logger|
        logger.info('Contact page')
      end
    end

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
* `log_tags`: An array of additional log tags to include. This can be strings, or you can include a `lambda` that will be evaluated. The `lambda` is passed a Rack `Request` object, and it must return an array of string values.  
  **Default**: `[]`
* `exclude_params`: An array of parameter names to be excluded from `GET` requests. By default, `GET` parameters are outputted in logs. If for example with the request `http://google.com/?one=dog&two=cat` you didn't want the `one` logged, you would set `exclude_params` to be `['one']`  
  **Default**: `[]`
* `include_log_severity`: Includes the log severity in the tagged output, such as `INFO`, `DEBUG` etc  
  **Default**: `true`

Sensible Logger will also respect the following Sinatra settings:

* `log_level`: The level at which your logger object should respect logs. See above example.  
  **Default**: `Logger::DEBUG`

## Examples

There is an example Sinatra app included in this repo. Here's how to use it:

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
* Excluded parameters are not included, in this example `two` based on `config.ru`
* The request log is minimal compared to out of the box Sinatra.
* `env['request_id']` is now available to group log lines from the same request together, or to use in additional services such as Sentry.

## FAQ

### Why is the timestamp absent?

To quote [lograge][link_lograge] (which was the inspiration for this library):

> The syntax is heavily inspired by the log output of the Heroku router. It doesn't include any timestamp by default, instead, it assumes you use a proper log formatter instead.

## Authors

By [David Winter](https://github.com/davidwinter), [Mark Sta Ana](https://github.com/booyaa) & [Anthony King](https://github.com/cybojenix)

## License

MIT

[link_lograge]: https://github.com/roidrage/lograge#lograge---taming-rails-default-request-logging
