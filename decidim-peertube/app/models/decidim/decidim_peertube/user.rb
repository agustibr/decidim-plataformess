# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    class PeertubeUser < ApplicationRecord
      self.table_name = "decidim_peertube_users"

      belongs_to :user, class_name: "Decidim::User", foreign_key: "decidim_user_id"

      def access_token_valid?
        access_token.present? && access_token_expires_at.future?
      end
    end
  end
end
