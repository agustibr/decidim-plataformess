# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/decidim_peertube/version"

Gem::Specification.new do |s|
  s.version = Decidim::DecidimPeertube::VERSION
  s.authors = ["Vera Rojman"]
  s.email = ["vera@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/Platoniq"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-decidim_peertube"
  s.summary = "..."
  s.description = "..."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-admin", Decidim::DecidimPeertube::DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::DecidimPeertube::DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", Decidim::DecidimPeertube::DECIDIM_VERSION
end
