module TLDExtract
  class Result
    attr_reader :subdomain, :domain, :suffix, :is_private

    def initialize(subdomain: '', domain: '', suffix: '', is_private: false)
      @subdomain = subdomain
      @domain = domain
      @suffix = suffix
      @is_private = is_private
    end

    def registered_domain
      return nil if domain.empty? || suffix.empty?
      "#{domain}.#{suffix}"
    end

    # Not needed
    def fqdn
      parts = []
      parts << subdomain unless subdomain.empty?
      parts << domain unless domain.empty?
      parts << suffix unless suffix.empty?
      parts.join('.')
    end

    # Not needed
    def to_s
      "Result(subdomain='#{subdomain}', domain='#{domain}', suffix='#{suffix}', is_private=#{is_private})"
    end
  end
end