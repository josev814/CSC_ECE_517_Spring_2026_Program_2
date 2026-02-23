require 'simplecov'
require 'simplecov-console'

SimpleCov.start 'rails' do
  # using track_files we're telling simplecov to include all rb files under app
  track_files "app/**/*.rb"

  add_filter '/app/jobs/'
  add_filter '/app/mailers'
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Console,
  SimpleCov::Formatter::SimpleFormatter
])
