# frozen_string_literal: true

require "decidim/decidim_peertube/admin"
require "decidim/decidim_peertube/admin_engine"
require "decidim/decidim_peertube/engine"
require "decidim/decidim_peertube/component"

module Decidim
  module DecidimPeertube
    include ActiveSupport::Configurable

    config_accessor :host do
      ENV.fetch("PEERTUBE_HOST", "peertube.plataformess.org")
    end
  end
end
