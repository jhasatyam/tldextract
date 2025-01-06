require 'tldextract'

# Test various URLs
urls = [
  'https://www.google.com',
  'http://forums.news.cnn.com',
  'https://example.co.uk',
  'http://192.168.1.1',
  'https://my.custom.subdomain.example.com'
]

urls.each do |url|
  result = TLDExtract.extract(url)
  puts "\nTesting URL: #{url}"
  puts "Subdomain: #{result.subdomain}"
  puts "Domain: #{result.domain}"
  puts "Suffix: #{result.suffix}"
  puts "FQDN: #{result.fqdn}"
  puts "Registered Domain: #{result.registered_domain}"
end 