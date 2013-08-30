Gem::Specification.new do |s|
  s.name = %q{time_jawn}
  s.version = "0.1.0"
  s.date = %q{2013-08-29}
  s.authors = ['Mark Platt']
  s.email = 'mplatt@tammantech.com'
  s.description = %q{TimeJawn makes class instances time zone aware. It doesn't care one iota about system, application or databse time as far as I can tell. It has some expectations and adds some useful methods.} 
  s.summary = %q{TimeJawn makes time zone aware class instances.}
  s.license = 'GPL-3.0'
  s.required_ruby_version = '>= 1.9.3'
  s.test_files = 'spec/time_jawn_spec.rb'
  s.files = [
    "lib/time_jawn.rb",
    "lib/time_jawn/time_jawn.rb"
  ]
  s.homepage    = 'http://tammantech.com'
  s.require_paths = ["lib"]
  s.add_runtime_dependency "activerecord", [">= 3.2"]
  s.add_runtime_dependency "activesupport", [">= 3.2"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"
  s.add_development_dependency "sqlite3-ruby"
  s.add_development_dependency "timecop"

end
