# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module DecidimPeertube
    module HasPeertubeSession
      extend ActiveSupport::Concern

      included do
        helper_method :current_peertube_user, :current_peertube_user_valid?

        private

        def current_peertube_user_valid?
          current_peertube_user&.access_token_valid?
        end

        def current_peertube_user
          PeertubeUser.find_by(decidim_user: current_user)
        end
      end
    end
  end
end