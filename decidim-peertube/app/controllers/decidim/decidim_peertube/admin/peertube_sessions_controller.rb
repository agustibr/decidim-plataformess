# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Admin
      class PeertubeVideosController < Decidim::Admin::Components::BaseController
        include HasPeertubeSession

        def new; end # render username and password form

        def create
          # POST username and password to
          #
          # <peertube-host>/api/v1/users/token
          #
          # with params:
          #
          # {
          #   client_id: "...",
          #   client_secret: "..."
          #   grant_type: "password"
          #   response_type: "code"
          #   username: "..."
          #   password: "..."
          # }
          #
          # this returns:
          #
          # {
          #   "access_token": "...",
          #   "token_type": "Bearer",
          #   "expires_in": 86399,
          #   "refresh_token": "..."
          # }
          #
          # Update or create DecidimPeertube::User for current_user with `access_token`
          # and `expires_in`<int> converted to `access_token_expires_at`<time>
        end
      end
    end
  end
end
