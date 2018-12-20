require 'rack/mock'

describe RequestLogger do
  let(:app) { double(:app, call: [200, {}, []]) }
  let(:logger) { double(:logger) }

  before do
    allow(Time).to receive(:now).and_return(1, 2)
    allow(logger).to receive(:info)
  end

  it 'logs the request' do
    env = Rack::MockRequest.env_for('http://localhost/test')
    env['logger'] = logger

    described_class.new(app).call(env)

    expect(logger).to have_received(:info).with('method=GET path=/test status=200 duration=1')
  end

  it 'logs the request and filters any excluded params' do
    env = Rack::MockRequest.env_for('http://localhost/test?one=two&three=four')
    env['logger'] = logger

    described_class.new(app, ['one']).call(env)

    expect(logger).to have_received(:info).with('method=GET path=/test status=200 duration=1 params={"three"=>"four"}')
  end

  it 'logs the request with no params if not GET' do
    env = Rack::MockRequest.env_for('http://localhost/test', method: 'POST', params: { one: 'two', three: 'four' })
    env['logger'] = logger

    described_class.new(app).call(env)

    expect(logger).to have_received(:info).with('method=POST path=/test status=200 duration=1')
  end

  after do
    allow(Time).to receive(:now).and_call_original
  end
end
