# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    class User < ApplicationRecord
      belongs_to :user, class_name: "Decidim::User", foreign_key: "decidim_user_id"
    end
  end
end
