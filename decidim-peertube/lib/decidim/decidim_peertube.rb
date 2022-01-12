# frozen_string_literal: true

require "decidim/decidim_peertube/admin"
require "decidim/decidim_peertube/admin_engine"
require "decidim/decidim_peertube/api"
require "decidim/decidim_peertube/engine"
require "decidim/decidim_peertube/component"

module Decidim
  module DecidimPeertube
    include ActiveSupport::Configurable

    config_accessor :credentials do
      {
        client_id: ENV.fetch("PEERTUBE_CLIENT_ID"),
        client_secret: ENV.fetch("PEERTUBE_CLIENT_SECRET")
      }
    end

    config_accessor :host do
      ENV.fetch("PEERTUBE_HOST", "peertube.plataformess.org")
    end
  end
end
