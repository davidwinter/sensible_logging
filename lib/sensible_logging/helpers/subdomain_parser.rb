class SubdomainParser
  attr_reader :tld_length

  def initialize(tld_length: 1)
    @tld_length = tld_length
  end

  def parse(host)
    domain_parts = host.split('.')

    return domain_parts[0] if domain_parts.length == 1

    main_domain_length = tld_length + 1
    subdomain_length = domain_parts.length - main_domain_length

    domain_parts[0...subdomain_length].join('.')
  end
end
