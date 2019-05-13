# frozen_string_literal: true

require 'logger'

# Wrap Logger objects to behave as IO objects in Rack
class IOWrap
  def initialize(logger, level: Logger::INFO)
    @logger = logger
    @level = level
  end

  def flush
    # No-Op
  end

  def puts(message)
    logger.add(level, message)
  end

  private

  attr_reader :logger, :level
end
