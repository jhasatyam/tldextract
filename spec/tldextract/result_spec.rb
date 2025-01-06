require 'spec_helper'

RSpec.describe TLDExtract::Result do
  describe '#registered_domain' do
    it 'returns domain and suffix combined' do
      result = described_class.new(domain: 'example', suffix: 'com')
      expect(result.registered_domain).to eq('example.com')
    end

    it 'returns nil when domain is empty' do
      result = described_class.new(domain: '', suffix: 'com')
      expect(result.registered_domain).to be_nil
    end

    it 'returns nil when suffix is empty' do
      result = described_class.new(domain: 'example', suffix: '')
      expect(result.registered_domain).to be_nil
    end
  end

  describe '#fqdn' do
    it 'returns full domain with all parts' do
      result = described_class.new(
        subdomain: 'www',
        domain: 'example',
        suffix: 'com'
      )
      expect(result.fqdn).to eq('www.example.com')
    end

    it 'skips empty parts' do
      result = described_class.new(
        subdomain: '',
        domain: 'example',
        suffix: 'com'
      )
      expect(result.fqdn).to eq('example.com')
    end
  end

  describe '#to_s' do
    it 'returns formatted string representation' do
      result = described_class.new(
        subdomain: 'www',
        domain: 'example',
        suffix: 'com'
      )
      expect(result.to_s).to eq("Result(subdomain='www', domain='example', suffix='com')")
    end
  end
end 