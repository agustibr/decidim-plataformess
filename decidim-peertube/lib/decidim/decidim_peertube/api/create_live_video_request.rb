# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Api
      class CreateLiveVideoRequest < Request
        # https://docs.joinpeertube.org/api-rest-reference.html#operation/addLive
        # https://docs.joinpeertube.org/use-create-upload-video

        def initialize(token:, channel_id:, video_name:, video_description:)
          post_authenticated(
            token,
            "videos/live",
            channelId: channel_id,
            name: video_name,
            description: video_description,
            saveReplay: true # ?
          )

          # which returns something like
          # {
          #   "video": {
          #     "id": 42,
          #     "uuid": "9c9de5e8-0a1e-484a-b099-e80766180a6d",
          #     "shortUUID": "2y84q2MQUMWPbiEcxNXMgC"
          #   }
          # }
        end
      end
    end
  end
end
