#!/usr/bin/env ruby

require 'bundler/setup'
require 'byebug'
require 'tldextract'

def debug_trie(trie, prefix = '')
  puts "#{prefix}Node: end=#{trie.end}, private=#{trie.is_private}"
  trie.matches.each do |key, value|
    puts "#{prefix}Key: #{key}"
    debug_trie(value, prefix + '  ')
  end
end

# Test your code
extractor = TLDExtract::Extractor.new
puts "\nDumping Trie structure:"
debug_trie(extractor.instance_variable_get(:@trie))

result = TLDExtract.extract('abc.wixsite.com', include_psl_private_domains: true)
puts "\nResult for abc.wixsite.com:"
puts result.registered_domain

# Test both with and without private domains
def test_extraction(url)
  puts "\nTesting URL: #{url}"
  
  puts "\nWithout private domains:"
  result = TLDExtract.extract(url, include_psl_private_domains: false)
  puts "Registered Domain: #{result.registered_domain}"
  
  puts "\nWith private domains:"
  result = TLDExtract.extract(url, include_psl_private_domains: true)
  puts "Registered Domain: #{result.registered_domain}"
end

test_extraction('abc.wixsite.com')
test_extraction('blog.blogspot.com')