# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Api
      # This class allows to make requests to the Peertube API
      class Request
        attr_accessor :response

        protected

        def get(url)
          response = Faraday.get(expand_url(url))

          @response = parse_response(response)
        end

        def get_authenticated(token, url)
          response = Faraday.get(expand_url(url)) do |request|
            authorize(request, token)
          end

          @response = parse_response(response)
        end

        def post(url, params)
          response = Faraday.post(expand_url(url), base_params.merge(params)) do |request|
          end

          @response = parse_response(response)
        end

        def post_authenticated(token, url, params)
          response = Faraday.post(expand_url(url)) do |request|
            authorize(request, token)
            request.params = base_params.merge(params)
          end

          @response = parse_response(response)
        end

        private

        def authorize(request, token)
          request.headers["Authorization"] = "Bearer #{token}"
        end

        def expand_url(url)
          URI.join(base_url, url)
        end

        def base_url
          URI.join("https://#{Decidim::DecidimPeertube.host}", "api/v1/")
        end

        def base_params
          Decidim::DecidimPeertube.credentials
        end

        def parse_response(response)
          @response = JSON.parse(response.body).to_h

          raise Decidim::DecidimPeertube::Api::Error, @response["error"] if @response["error"]

          @response
        end
      end
    end
  end
end
