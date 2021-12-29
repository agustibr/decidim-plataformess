# frozen_string_literal: true

require "decidim/decidim_peertube/admin"
require "decidim/decidim_peertube/engine"
require "decidim/decidim_peertube/admin_engine"

module Decidim
  module DecidimPeertube
    include ActiveSupport::Configurable

    config_accessor :host do
      ENV.fetch("PEERTUBE_HOST", "peertube.plataformess.org")
    end
  end
end

# Engines to handle logic unrelated to participatory spaces or components

Decidim.register_global_engine(
  :decidim_decidim_peertube, # this is the name of the global method to access engine routes
  ::Decidim::DecidimPeertube::Engine,
  at: "/decidim_peertube"
)
