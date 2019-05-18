# Pronto::Checkstyle

[![Gem Version](https://badge.fury.io/rb/pronto-checkstyle.svg)](http://badge.fury.io/rb/pronto-checkstyle)
[![Build Status](https://travis-ci.org/seikichi/pronto-checkstyle.svg?branch=master)](https://travis-ci.org/seikichi/pronto-checkstyle)
[![Coverage Status](https://coveralls.io/repos/seikichi/pronto-checkstyle/badge.svg?branch=master&service=github)](https://coveralls.io/github/seikichi/pronto-checkstyle?branch=master)

[Pronto](https://github.com/mmozuras/pronto) runner for [checkstyle](http://checkstyle.sourceforge.net/).

## Configuration

You need to specify location of checkstyle reports by passing `PRONTO_CHECKSTYLE_REPORTS_DIR` env variable e.g:

```bash
PRONTO_CHECKSTYLE_REPORTS_DIR=build/reports/checkstyle/ pronto run --index
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pronto-checkstyle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pronto-checkstyle

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seikichi/pronto-checkstyle.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
