$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pronto/checkstyle'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
]
SimpleCov.start { add_filter('test') }

require 'test/unit'
