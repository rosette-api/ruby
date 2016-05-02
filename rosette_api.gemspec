lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 2.0.0'

  s.name               = 'rosette_api'
  s.version            = '1.0.1'
  s.license            = 'MIT'

  s.summary       = 'Rosette API gem that supports multilingual text-analytics.'
  s.description = %q{A Ruby client binding for the Rosette API, a multilingual text analytics RESTful API.}



  s.authors = ['Basis Technology Corp']
  s.email = %q{support@rosette.com}
  s.homepage = %q{https://developer.rosette.com/}
  s.date = %q{2016-04-29}

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r{^(bin|lib)/|^.rubocop.yml$})
  s.test_files = ['test/tests_spec.rb']
  s.require_paths = ['lib']
  s.default_executable = 'rosette_api'

  s.add_runtime_dependency('rubysl-securerandom', '~> 2.0')
end