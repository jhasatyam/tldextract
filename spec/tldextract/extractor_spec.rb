require 'spec_helper'

RSpec.describe TLDExtract do
  describe '.extract' do
    context 'with valid URLs' do
      {
        'https://forums.news.cnn.com/' => {
          subdomain: 'forums.news',
          domain: 'cnn',
          suffix: 'com'
        },
        'http://www.google.co.uk' => {
          subdomain: 'www',
          domain: 'google',
          suffix: 'co.uk'
        }
      }.each do |url, expected|
        it "correctly extracts #{url}" do
          result = described_class.extract(url)
          expect(result.subdomain).to eq(expected[:subdomain])
          expect(result.domain).to eq(expected[:domain])
          expect(result.suffix).to eq(expected[:suffix])
        end
      end
    end

    context 'with private domains' do
      it 'handles private domains correctly based on include_psl_private_domains flag' do
        url = 'blog.blogspot.com'

        # Without private domains
        result = described_class.extract(url)
        expect(result.registered_domain).to eq('blogspot.com')

        # With private domains
        result = described_class.extract(url, include_psl_private_domains: true)
        expect(result.registered_domain).to eq('blog.blogspot.com')
      end
    end
  end
end