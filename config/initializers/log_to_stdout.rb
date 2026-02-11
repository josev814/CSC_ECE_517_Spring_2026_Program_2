# This initializer forces Rails to log everything to STDOUT
#   if the ENV DOCKER is set and true

Rails.application.configure do
  if ENV.has_key?('DOCKER') && ENV['DOCKER']
    # Redirect STDERR to STDOUT so all output goes to one stream
    $stderr.reopen($stdout)
    $stderr.sync = true
    $stdout.sync = true

    # Create a logger that writes to STDOUT
    stdout_logger = ActiveSupport::Logger.new(STDOUT)
    stdout_logger.formatter = config.log_formatter

    # Wrap with tagged logging (adds request IDs, etc.)
    config.logger = ActiveSupport::TaggedLogging.new(stdout_logger)

    # Ensure ActiveRecord logs also go to STDOUT
    if defined?(ActiveRecord)
      ActiveRecord::Base.logger = config.logger
    end

    # Optional: Set log level (can be overridden by ENV["LOG_LEVEL"])
    config.log_level = (ENV["LOG_LEVEL"] || :debug).to_sym
  end
end
