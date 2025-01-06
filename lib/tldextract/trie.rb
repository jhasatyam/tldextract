module TLDExtract
  class Trie
    attr_accessor :matches, :end, :is_private

    def initialize
      @matches = {}
      @end = false
      @is_private = false
    end

    def self.create(public_suffixes, private_suffixes)
      public_trie = new
      private_trie = new

      # Add public suffixes
      public_suffixes.each do |suffix|
        parts = suffix.split('.')
        add_suffix(public_trie, parts.reverse, false)
      end

      # Add private suffixes
      private_suffixes.each do |suffix|
        parts = suffix.split('.')
        add_suffix(private_trie, parts.reverse, true)
      end

      # Return both tries
      {
        public: public_trie,
        private: private_trie
      }
    end

    private

    def self.add_suffix(node, parts, is_private)
      if parts.empty?
        node.end = true
        node.is_private = is_private
        return
      end

      part = parts[0]
      node.matches[part] ||= new
      add_suffix(node.matches[part], parts[1..-1], is_private)
    end
  end
end