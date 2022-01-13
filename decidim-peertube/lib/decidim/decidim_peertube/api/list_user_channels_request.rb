# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Api
      class ListUserChannelsRequest < Request
        # list available channels for user
        # /api/v1/accounts/<peertube-username>/video-channels

        def initialize(username:)
          get(
            "accounts/#{username}/video-channels"
          )
        end
      end
    end
  end
end
