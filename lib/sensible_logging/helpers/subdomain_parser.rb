# frozen_string_literal: true

# Returns subdomains from a full qualified domain name
class SubdomainParser
  attr_reader :tld_length

  def initialize(tld_length: 1)
    @tld_length = tld_length
  end

  def parse(host)
    domain_parts = host.split('.')

    return domain_parts[0] if domain_parts.size == 1

    main_domain_length = tld_length + 1
    subdomain_length = domain_parts.size - main_domain_length

    subdomain_parts = domain_parts[0...subdomain_length]

    return nil if subdomain_parts.empty?

    subdomain_parts.join('.')
  end
end
