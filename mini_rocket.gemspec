# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mini_rocket/version'

Gem::Specification.new do |spec|
  spec.name          = 'mini_rocket'
  spec.version       = MiniRocket::VERSION
  spec.authors       = ['Igor Galeta']
  spec.email         = ['galeta.igor@gmail.com']

  spec.summary       = %q{Simple CMS}
  spec.description   = %q{Simple CMS with nice admin theme}
  spec.homepage      = 'https://github.com/galetahub/mini_rocket'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'inherited_resources', '~> 1.10'
  spec.add_dependency 'kaminari', '~> 1.1'
  spec.add_dependency 'railties', '>= 5.0'
  spec.add_dependency 'responders', '~> 3.0'
  spec.add_dependency 'simple_form', '~> 4.1'
  spec.add_dependency 'slim', '~> 4.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
