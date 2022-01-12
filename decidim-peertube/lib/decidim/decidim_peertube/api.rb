# frozen_string_literal: true

require_relative "api/request"
require_relative "api/authentication_request"

module Decidim
  module DecidimPeertube
    # This holds the Decidim::DecidimPeertube::Api namespace.
    module Api
      class Error < StandardError; end
    end
  end
end
