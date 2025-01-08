require 'byebug'

module TLDExtract
  class Extractor
    SCHEME_RE = /^([a-zA-Z][a-zA-Z0-9+.-]*:)?\/\//
    VALID_DOMAIN_CHARS = /\A(?!.*[\s])(?!(?:.*\.\.)|(?:.*\s))([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}\z/
    PUBLIC_SUFFIX_LIST_URL = 'https://publicsuffix.org/list/public_suffix_list.dat'

    def initialize
      @cache_file = File.join("/tmp", '.tld_set')
      @suffix_list_urls = [PUBLIC_SUFFIX_LIST_URL]
      @fallback_to_snapshot = true
      load_trie
    end

    def extract(url, include_psl_private_domains: false)
      @include_psl_private_domains = include_psl_private_domains
      host = extract_hostname(url.downcase.to_s.strip)
      return Result.new unless host.match?(VALID_DOMAIN_CHARS)
      matches = extract_domain_parts(host)
      Result.new(
        subdomain: matches[:subdomain],
        domain: matches[:domain],
        suffix: matches[:tld],
        is_private: matches[:is_private]
      )
    end

    private

    def load_trie
      suffix_data = load_suffix_data
      @tries = TLDExtract::Trie.create(suffix_data[:public], suffix_data[:private])
    end

    def load_suffix_data
      return load_snapshot unless @cache_file

      if File.exist?(@cache_file)
        parse_suffix_list(File.read(@cache_file, encoding: 'UTF-8'))
      else
        fetch_and_cache_suffix_list
      end
    rescue StandardError => e
      puts "Warning: Failed to load suffix list: #{e.message}"
      load_snapshot
    end

    def extract_hostname(url)
      url = url.sub(SCHEME_RE, '')
      url.partition("/").first
         .partition("?").first
         .partition("#").first
         .rpartition("@").last
         .partition(":").first.strip
         .gsub(/^\.+|\.+$/, '')
    end

    def find_matches(reversed_labels)
      if @include_psl_private_domains
        private_match = check_trie(@tries[:private], reversed_labels)
        return private_match if private_match
      end
      check_trie(@tries[:public], reversed_labels)
    end

    def check_trie(trie, reversed_labels)
      node = trie
      suffix_length = 0
      last_match = nil
      is_private = false

      reversed_labels.each_with_index do |label, i|
        # Check for exact match
        next_node = node.matches[label]
        break unless next_node

        node = next_node

        # Update match info if this is a valid end node
        if node.end
          suffix_length = i + 1
          last_match = node
          is_private = node.is_private
        end
      end

      return nil unless last_match

      {
        suffix_length: suffix_length,
        is_private: is_private
      }
    end

    def extract_domain_parts(hostname)
      return { subdomain: '', domain: '', tld: '', is_private: false } if hostname.empty?

      labels = hostname.split('.')
      matches = find_matches(labels.reverse)

      return { subdomain: '', domain: '', tld: '', is_private: false } unless matches

      suffix_length = matches[:suffix_length]

      # Calculate the total number of labels and the domain index
      domain_index = labels.length - suffix_length - 1

      if @include_psl_private_domains
        # For private domains (e.g., blogspot.com)
        private_suffix = labels[-suffix_length..-1].join('.')
        {
          subdomain: domain_index > 0 ? labels[0...domain_index].join('.') : '',
          domain: domain_index >= 0 ? labels[domain_index] : '',
          tld: private_suffix,
          is_private: matches[:is_private]
        }
      else
        # For public domains or when private domains are disabled
        {
          subdomain: domain_index > 0 ? labels[0...domain_index].join('.') : '',
          domain: domain_index >= 0 ? labels[domain_index] : '',
          tld: domain_index >= 0 ? labels[-suffix_length..-1].join('.') : labels.join('.'),
          is_private: matches[:is_private]
        }
      end
    end

    def fetch_and_cache_suffix_list
      response = HTTParty.get(@suffix_list_urls.first)
      if response.success?
        content = response.body.force_encoding('UTF-8')
        File.write(@cache_file, content, encoding: 'UTF-8')
        parse_suffix_list(content)
      else
        load_snapshot
      end
    rescue StandardError => e
      load_snapshot
    end

    def load_snapshot
      snapshot_path = File.join(File.dirname(__FILE__), '..', 'data', 'tld_set_snapshot.json')
      if File.exist?(snapshot_path)
        require 'json'
        JSON.parse(File.read(snapshot_path, encoding: 'UTF-8'), symbolize_names: true)
      else
        { public: ['com', 'org', 'net', 'edu', 'gov', 'mil', 'co.uk'], private: [] }
      end
    end

    def parse_suffix_list(content)
      public_suffixes = []
      private_suffixes = []
      in_private_section = false

      content.each_line do |line|
        line = line.chomp.strip
        next if line.empty?
        if line.match?("BEGIN PRIVATE DOMAINS")
          in_private_section = true
          next
        end

        if line.start_with?('!')
          public_suffixes << line[1..-1] if @include_psl_private_domains
        else
          if in_private_section
            private_suffixes << line.split.first
          else
            public_suffixes << line
          end
        end
      end

      { public: public_suffixes, private: private_suffixes }
    end
  end
end 