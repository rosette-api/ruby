# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.0.0'
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }

  spec.name = 'rosette_api'
  spec.version = '1.37.0'
  spec.license = 'Apache-2.0'

  spec.summary = 'A Ruby interface for Babel Street Analytics Server and Hosted Services'
  spec.description =
    'Our product is a full text processing pipeline from data preparation to extracting the most relevant information and' \
    'analysis utilizing precise, focused AI that has built-in human understanding. Text Analytics provides foundational' \
    'linguistic analysis for identifying languages and relating words. The result is enriched and normalized text for' \
    'high-speed search and processing without translation.' \
    'Text Analytics extracts events and entities — people, organizations, and places — from unstructured text and adds the' \
    'structure of associating those entities into events that deliver only the necessary information for near real-time' \
    'decision making. Accompanying tools shorten the process of training AI models to recognize domain-specific events.' \
    'The product delivers a multitude of ways to sharpen and expand search results. Semantic similarity expands search' \
    'beyond keywords to words with the same meaning, even in other languages. Sentiment analysis and topic extraction help' \
    'filter results to what’s relevant.'

  spec.authors = ['Analytics by Babel Street']
  spec.email = 'analyticssupport@babelstreet.com'
  spec.homepage = 'https://developer.babelstreet.com/'

  spec.files = Dir['LICENSE', 'README.md', 'lib/**/*', 'examples/**/*']
  spec.require_paths = ['lib']
end
