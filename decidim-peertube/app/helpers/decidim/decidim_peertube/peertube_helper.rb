# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module PeertubeHelper
      def peertube_embed_url
        current_component.settings.video_url.gsub("watch", "embed")
      end
    end
  end
end
