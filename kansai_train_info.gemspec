require_relative 'lib/kansai_train_info/version'

Gem::Specification.new do |spec|
  spec.name          = 'kansai_train_info'
  spec.version       = KansaiTrainInfo::VERSION
  spec.authors       = ['o8n']
  spec.email         = ['m.okamotchan@gmail.com']
  spec.summary       = 'check train info in kansai area'
  spec.description   = 'you can check train info in kansai area'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.0')

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir['lib/**/*.rb'] + ['README.md', 'LICENSE.txt']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.15'
  spec.add_dependency 'thor', '~> 1.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
