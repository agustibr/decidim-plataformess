# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Api
      class AuthenticationRequest < Request
        def initialize(username:, password:)
          post(
            "users/token",
            grant_type: "password",
            response_type: "code",
            username: username,
            password: password
          )
        end

        # POST username and password to
        #
        # <peertube-host>/api/v1/users/token
        #
        # with params:
        #
        # {
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
