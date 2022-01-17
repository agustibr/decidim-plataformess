# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    # Visit Peertube docs for further reference https://docs.joinpeertube.org/api-rest-reference.html#operation/addLive
    class PeertubeVideoForm < Decidim::Form
      include Decidim::HasUploadValidations

      attribute :channel_id, String
      attribute :video_name, String
      attribute :video_description, String
      attribute :privacy, Integer

      attribute :permanent_live, Boolean
      attribute :comments_enabled, Boolean
      attribute :downloads_enabled, Boolean

      # FUTURE attribute :tags, Array[String]

      validates :channel_id, :video_name, :video_description, :privacy, presence: true
      validates :video_name, length: { in: 3..120 }
      validates :privacy, numericality: { only_integer: true, in: [1..2] } # 1: Public, 2: Unlisted

      # FUTURE
      # validates_upload :preview_file
      # mount_uploader :preview_file, Decidim::ImageUploader

      # FUTURE
      # validates_upload :thumbnail_file
      # mount_uploader :thumbnail_file, Decidim::ImageUploader
    end
  end
end
