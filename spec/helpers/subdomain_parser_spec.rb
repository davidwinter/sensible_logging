# frozen_string_literal: true

describe SubdomainParser do
  it 'parses a subdomain out of a host' do
    subdomain = described_class.new.parse('www.blah.google.com')

    expect(subdomain).to eq('www.blah')
  end

  it 'parses a subdomain out of a host with different length tld' do
    subdomain = described_class.new(tld_length: 2).parse('www.foo.google.co.uk')

    expect(subdomain).to eq('www.foo')
  end

  it 'parses a non-domain correctly' do
    subdomain = described_class.new(tld_length: 0).parse('localhost')

    expect(subdomain).to eq('localhost')
  end

  it 'host does not use a subdomain' do
    subdomain = described_class.new.parse('google.com')

    expect(subdomain).to eq(nil)
  end
end
