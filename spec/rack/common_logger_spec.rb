# frozen_string_literal: true

class MyApp
  def call(env); end
end

class MyLogger
  def write; end
end

describe Rack::CommonLogger do
  it 'disables common logger by default' do
    logger = instance_double(MyLogger, write: false)

    common_logger = described_class.new(MyApp.new, logger)

    common_logger.call({})

    expect(logger).not_to have_received(:write)
  end
end
