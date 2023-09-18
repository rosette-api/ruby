# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.3.0'

  s.name = 'rosette_api'
  s.version = '1.14.4'
  s.license = 'Apache-2.0'

  s.summary = 'A Ruby interface for Rosette Text Analytics Platform.'
  s.description =
    'The Rosette Text Analytics Platform uses natural language processing, ' \
    'statistical modeling, and machine learning to analyze unstructured and ' \
    'semi-structured text across 364 language-encoding-script combinations, ' \
    'revealing valuable information and actionable data. Rosette provides ' \
    'endpoints for extracting entities and relationships, translating and ' \
    'comparing the similarity of names, categorizing and adding linguistic ' \
    'tags to text and more.'

  s.authors = ['Basis Technology Corp']
  s.email = 'support@rosette.com'
  s.homepage = 'https://developer.rosette.com/'
  s.date = '2020-06-16'

  s.files = Dir['LICENSE', 'README.md', 'lib/**/*', 'examples/**/*']
  s.require_paths = ['lib']
end
