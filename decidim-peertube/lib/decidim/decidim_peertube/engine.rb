# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module DecidimPeertube
    # This is the engine that runs on the public interface of decidim_peertube.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::DecidimPeertube

      routes do
        root to: "peertube_videos#show"
      end
    end
  end
end
