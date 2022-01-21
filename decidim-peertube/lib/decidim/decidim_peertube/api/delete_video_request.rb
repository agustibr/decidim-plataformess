# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Api
      class DeleteVideoRequest < Request
        # https://docs.joinpeertube.org/api-rest-reference.html#operation/delVideo

        def initialize(token:, id:)
          delete_authenticated(
            token,
            "videos/#{id}"
          )
        end
      end
    end
  end
end
