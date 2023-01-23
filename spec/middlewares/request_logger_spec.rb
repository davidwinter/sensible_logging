# frozen_string_literal: true

require 'rack/mock'

describe RequestLogger do
  let(:app) { instance_double(App, call: [200, {}, []]) }
  let(:logger) { instance_double(Logger) }

  before do
    allow(Time).to receive(:now).and_return(
      Time.new(2022, 12, 19, 0, 0, 0),
      Time.new(2022, 12, 19, 0, 0, 1)
    )
    allow(logger).to receive(:info)
  end

  after do
    allow(Time).to receive(:now).and_call_original
  end

  it 'logs the request' do
    env = Rack::MockRequest.env_for('http://localhost/test')
    env['logger'] = logger

    described_class.new(app).call(env)

    expect(logger).to have_received(:info).with('method=GET path=/test client=n/a status=200 duration=1.0')
  end

  it 'logs the request with REMOTE_ADDR' do
    env = Rack::MockRequest.env_for('http://localhost/test', 'REMOTE_ADDR' => '123.456.789.123')
    env['logger'] = logger

    described_class.new(app).call(env)

    expect(logger).to have_received(:info).with('method=GET path=/test client=123.456.789.123 status=200 duration=1.0')
  end

  it 'logs the request with X_FORWARDED_FOR' do
    env = Rack::MockRequest.env_for('http://localhost/test', 'HTTP_X_FORWARDED_FOR' => '123.456.789.123')
    env['logger'] = logger

    described_class.new(app).call(env)

    expect(logger).to have_received(:info).with('method=GET path=/test client=123.456.789.123 status=200 duration=1.0')
  end

  it 'logs the request with no params if not GET' do
    env = Rack::MockRequest.env_for('http://localhost/test', method: 'POST', params: { one: 'two', three: 'four' })
    env['logger'] = logger

    described_class.new(app).call(env)

    expect(logger).to have_received(:info).with('method=POST path=/test client=n/a status=200 duration=1.0')
  end

  it 'rescues and logs the request with no params if Rack::Multipart::MultipartPartLimitError is raised' do
    data = invalid_multipart_body
    env = Rack::MockRequest.env_for('http://localhost/test', {
                                'CONTENT_TYPE' => 'multipart/form-data; boundary=myboundary',
                                'CONTENT_LENGTH' => data.bytesize,
                                input: StringIO.new(data)
                              })
    env['logger'] = logger
    described_class.new(app).call(env)

    expect(logger).to have_received(:info).with('method=GET path=/test client=n/a status=200 duration=1.0')
  end
end
