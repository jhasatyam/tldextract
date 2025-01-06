class ExtractResult
  attr_reader :subdomain, :domain, :suffix, :is_private

  def initialize(subdomain, domain, suffix, is_private)
    @subdomain = subdomain
    @domain = domain
    @suffix = suffix
    @is_private = is_private
  end

  def registered_domain
    return "" unless @suffix && @domain
    "#{@domain}.#{@suffix}"
  end

  def fqdn
    return "" unless @suffix && (@domain || @is_private)
    [@subdomain, @domain, @suffix].reject(&:empty?).join('.')
  end

  def to_s
    "ExtractResult(subdomain='#{@subdomain}', domain='#{@domain}', " \
      "suffix='#{@suffix}', is_private=#{@is_private})"
  end
end
