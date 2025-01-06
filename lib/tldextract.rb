require 'set'
require 'tldextract/version'
require 'tldextract/result'
require 'tldextract/trie'
require 'tldextract/extractor'
require 'addressable/uri'
require 'httparty'
require 'byebug'


module TLDExtract
  class DomainInvalidError < StandardError; end


  class ExtractorService
    class << self

      def instance
        @instance ||= Extractor.new
      end

      def extract(url, include_psl_private_domains: false)
        parsed_domain = instance.extract(url, include_psl_private_domains: include_psl_private_domains).registered_domain
        if parsed_domain.nil?
          raise DomainInvalidError.new("unable to parse domain: #{url}")
        end
        parsed_domain
      end
    end
  end
end