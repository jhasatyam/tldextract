require 'set'
require 'tldextract/version'
require 'tldextract/result'
require 'tldextract/trie'
require 'tldextract/extractor'
require 'addressable/uri'
require 'httparty'
require 'byebug'


module TLDExtract
  class Error < StandardError; end

  PUBLIC_SUFFIX_LIST_URL = 'https://publicsuffix.org/list/public_suffix_list.dat'

  class << self
    def instance
      @instance ||= Extractor.new
    end

    def extract(url, include_psl_private_domains: false)
      instance.extract(url, include_psl_private_domains: include_psl_private_domains)
    end
  end
end