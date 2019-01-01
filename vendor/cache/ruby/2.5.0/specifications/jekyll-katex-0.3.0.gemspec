# -*- encoding: utf-8 -*-
# stub: jekyll-katex 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-katex".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jerry Lin".freeze]
  s.date = "2018-09-26"
  s.description = "Adds a liquid tag you can use to do server-side rendering of latex math using KaTeX".freeze
  s.email = "linjer@gmail.com".freeze
  s.homepage = "https://github.com/linjer/jekyll-katex".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.1".freeze)
  s.rubygems_version = "3.0.2".freeze
  s.summary = "Jekyll plugin for easy KaTeX math server-side rendering.".freeze

  s.installed_by_version = "3.0.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<execjs>.freeze, ["~> 2.7"])
      s.add_runtime_dependency(%q<jekyll>.freeze, ["~> 3.8"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12.3"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.56.0"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16"])
    else
      s.add_dependency(%q<execjs>.freeze, ["~> 2.7"])
      s.add_dependency(%q<jekyll>.freeze, ["~> 3.8"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_dependency(%q<rake>.freeze, ["~> 12.3"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.56.0"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
    end
  else
    s.add_dependency(%q<execjs>.freeze, ["~> 2.7"])
    s.add_dependency(%q<jekyll>.freeze, ["~> 3.8"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.3"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.7"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.56.0"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
  end
end
