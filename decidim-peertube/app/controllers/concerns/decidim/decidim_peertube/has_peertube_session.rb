# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module DecidimPeertube
    module HasPeertubeSession
      extend ActiveSupport::Concern

      included do
        helper_method :current_peertube_user, :current_peertube_user_valid?, :peertube_user_channels

        private

        def current_peertube_user_valid?
          current_peertube_user&.access_token_valid?
        end

        def current_peertube_user
          Decidim::DecidimPeertube::PeertubeUser.find_by(user: current_user)
        end

        def check_peertube_session
          redirect_to new_peertube_session_path unless current_peertube_user_valid?
        end

        def peertube_user_channels
          @peertube_user_channels ||=
            current_peertube_user.video_channels ||
            Decidim::DecidimPeertube::Api::ListUserChannelsRequest.new(username: current_peertube_user.peertube_username).response["data"]
        end
      end
    end
  end
end
