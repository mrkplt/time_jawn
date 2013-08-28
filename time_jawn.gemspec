Gem::Specification.new do |s|
  s.name = %q{time_jawn}
  s.version = "0.0.0"
  s.date = %q{2013-08-26}
  s.authors = %w(Mark)
  s.email = 'mark@mrkplt.com'
  s.description = %q{TimeJawn makes time zone aware class instances.} 
  s.summary = %q{TimeJawn makes time zone aware class instances.}
  s.files = [
    "lib/time_jawn.rb",
    "lib/time_jawn/time_jawn.rb"
  ]
  s.require_paths = ["lib"]
  s.add_runtime_dependency "activerecord", [">= 3.2"]
  s.add_runtime_dependency "activesupport", [">= 3.2"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"
  s.add_development_dependency "sqlite3-ruby"

end
