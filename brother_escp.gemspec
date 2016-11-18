# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brother_escp/version'

Gem::Specification.new do |spec|
  spec.name          = 'brother_escp'
  spec.version       = BrotherEscp::VERSION
  spec.authors       = ['David Bourguignon']
  spec.email         = ['tal.bourguignon@laposte.net']

  spec.summary       = 'Print text and images to a Brother label printer with ESC/P.'
  spec.description   = 'Print text and images to a Brother label printer with ESC/P.'
  spec.homepage      = 'https://github.com/dbourguignon/brother_escp'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  # spec.add_development_dependency 'simplecov', '~> 3.0'

  spec.add_dependency 'chunky_png'
end
