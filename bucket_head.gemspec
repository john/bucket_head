# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bucket_head}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John McGrath"]
  s.date = %q{2009-07-14}
  s.description = %q{Gem to hit URI's and stick their contents on S3}
  s.email = %q{john@wordie.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".specification",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "lib/bucket_head.rb",
     "test/bucket_head_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/John/bucket_head}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{TODO}
  s.test_files = [
    "test/bucket_head_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
