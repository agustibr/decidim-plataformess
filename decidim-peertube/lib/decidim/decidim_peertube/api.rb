# frozen_string_literal: true

require_relative "api/request"
require_relative "api/authentication_request"
require_relative "api/create_live_video_request"
require_relative "api/delete_video_request"
require_relative "api/get_live_video_info_request"
require_relative "api/get_user_info_request"
require_relative "api/list_user_channels_request"

module Decidim
  module DecidimPeertube
    # This holds the Decidim::DecidimPeertube::Api namespace.
    module Api
      def self.base_url
        Decidim::DecidimPeertube.url("api/v1/")
      end

      class Error < StandardError; end
    end
  end
end
