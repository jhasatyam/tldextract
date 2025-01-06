#!/usr/bin/env ruby

require 'bundler/setup'
require 'tldextract'

def prompt_and_test
  print "\nEnter URL to test (or 'quit' to exit): "
  url = gets.chomp
  return false if url.downcase == 'quit'

  result = TLDExtract.extract(url)
  puts "\nResults for: #{url}"
  puts "Subdomain: #{result.subdomain}"
  puts "Domain: #{result.domain}"
  puts "Suffix: #{result.suffix}"
  puts "FQDN: #{result.fqdn}"
  puts "Registered Domain: #{result.registered_domain}"
  true
end

puts "TLDExtract Manual Testing"
puts "========================"

while prompt_and_test
end 