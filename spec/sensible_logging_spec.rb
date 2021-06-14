# frozen_string_literal: true

class MyApp
  def call(env)
  end
end

describe SensibleLogging do
  it 'has a version number' do
    expect(SensibleLogging::VERSION).not_to be nil
  end
end

describe Rack::CommonLogger do
  it 'disables common logger by default' do
    logger = instance_double('MyLogger', write: false)

    common_logger = Rack::CommonLogger.new(MyApp.new, logger)

    common_logger.call({})

    expect(logger).to_not have_received(:write)
  end
end
