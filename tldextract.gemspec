require_relative 'lib/tldextract/version'

Gem::Specification.new do |spec|
  spec.name          = 'tldextract'
  spec.version       = TLDExtract::VERSION
  spec.authors       = ['Satyam Jha']
  spec.email         = ['jhasatyam166@gmail.com']
  spec.summary       = 'Extract subdomain, domain, and TLD from URLs'
  spec.description   = "tldextract accurately separates a URL's subdomain, domain, and public suffix, using the Public Suffix List (PSL)."
  spec.homepage      = 'https://github.com/jhasatyam166/tldextract'
  spec.license       = 'MIT'
  
  spec.required_ruby_version = '>= 2.6.0'

  # Specify which files should be added to the gem when it is released
  spec.files = Dir[
    'lib/**/*',
    'lib/data/*',
    'bin/*',
    'LICENSE',
    'README.md',
    'CHANGELOG.md'
  ]
  
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'addressable', '~> 2.8'    # For URL parsing
  spec.add_dependency 'httparty', '~> 0.21.0'    # For downloading suffix list

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.18'
  spec.add_development_dependency 'vcr', '~> 6.1'
  spec.add_development_dependency 'byebug', '~> 11.1'
end