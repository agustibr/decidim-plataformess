# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Api
      class GetLiveVideoInfoRequest < Request
        # https://docs.joinpeertube.org/api-rest-reference.html#operation/getLiveId

        def initialize(token:, video_id:)
          get_authenticated(
            token,
            "videos/live/#{video_id}"
            # where <video-id> is either id (integer) or UUIDv4 (string) or shortUUID (string)
          )

          # retrieves streaming data for video, e.g.:
          #
          #   {
          #     "rtmpUrl": "...",
          #     "rtmpsUrl": "...",
          #     "streamKey": "...",
          #     "saveReplay": true,
          #     "permanentLive": true
          # }
        end
      end
    end
  end
end
