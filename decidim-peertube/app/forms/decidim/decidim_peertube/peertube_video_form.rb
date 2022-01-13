# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    class PeertubeVideoForm < Decidim::Form
      attribute :channel_id, String
      attribute :video_name, String
      attribute :video_description, String

      validates :channel_id, :video_name, presence: true
    end
  end
end
