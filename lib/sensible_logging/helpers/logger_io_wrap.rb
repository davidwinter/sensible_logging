require 'logger'

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
