# Rack WebProfiler

A Rack profiler for web application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-webprofiler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-webprofiler

### Rack

```ruby
home = lambda { |_env|
  [200, { "Content-Type" => "text/html" }, ["<html><body>Hello world!</body></html>"]]
}

builder = Rack::Builder.new do
  use Rack::WebProfiler

  map('/') { run home }
end

run builder
```

### Sinatra

```ruby
require "rack-webprofiler"

class App < Sinatra::Base
  use Rack::WebProfiler
end
```

### Rails

The WebProfiler is automatically enabled.


## Configuration

You can specify the temporary directory. It is used to save the SQlite database.

```ruby
use Rack::WebProfiler, tmp_dir: File.expand_path("/tmp", __FILE__)
```

## Usage

TODO


## Examples

See [the examples](./examples).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nicolas-brousse/rack-webprofiler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code Status

[![Build Status](https://travis-ci.org/nicolas-brousse/rack-webprofiler.svg?branch=master)](https://travis-ci.org/nicolas-brousse/rack-webprofiler)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Alternatives & comments

* https://github.com/MiniProfiler/rack-mini-profiler
* https://github.com/dawanda/rack-profiler

This project is in part inspired by the [Symfony WebProfiler Bundle](https://github.com/symfony/web-profiler-bundle).
