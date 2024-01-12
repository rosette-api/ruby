# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.0.0'
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }

  spec.name = 'rosette_api'
  spec.version = '1.14.4'
  spec.license = 'Apache-2.0'

  spec.summary = 'A Ruby interface for Rosette Text Analytics Platform.'
  spec.description =
    'The Rosette Text Analytics Platform uses natural language processing, ' \
    'statistical modeling, and machine learning to analyze unstructured and ' \
    'semi-structured text across 364 language-encoding-script combinations, ' \
    'revealing valuable information and actionable data. Rosette provides ' \
    'endpoints for extracting entities and relationships, translating and ' \
    'comparing the similarity of names, categorizing and adding linguistic ' \
    'tags to text and more.'

  spec.authors = ['Basis Technology Corp']
  spec.email = 'support@rosette.com'
  spec.homepage = 'https://developer.rosette.com/'

  spec.files = Dir['LICENSE', 'README.md', 'lib/**/*', 'examples/**/*']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('rubysl-securerandom', '~> 2.0')
end
