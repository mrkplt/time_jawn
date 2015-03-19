require './lib/time_jawn/version.rb'

Gem::Specification.new do |s|
  s.name = %q{time_jawn}
  s.version = TimeJawn::VERSION
  s.date = %q{2015-01-07}
  s.authors = ['Mark Platt']
  s.email = 'mark@mrkplt.com'
  s.description = %q{TimeJawn makes class instances time zone aware. It doesn't care one iota about system, application or database time as far as I can tell. It has some expectations and adds some useful methods.}
  s.summary = %q{TimeJawn makes time zone aware class instances.}
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.0'
  s.test_files = 'spec/time_jawn_spec.rb'
  s.files = [
    "lib/time_jawn.rb",
    "lib/time_jawn/time_jawn.rb",
    "lib/time_jawn/time_jawn_private_class_methods.rb"
  ]
  s.homepage    = 'https://github.com/mrkplt/time_jawn'
  s.require_paths = ["lib"]
  s.add_runtime_dependency "activerecord", ["= 4.2.1"]
  s.add_runtime_dependency "activesupport", ["= 4.2.1"]

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "timecop"

end
