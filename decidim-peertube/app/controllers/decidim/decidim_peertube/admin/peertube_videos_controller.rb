# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Admin
      class PeertubeVideosController < Decidim::Admin::Components::BaseController
        include HasPeertubeSession

        def edit; end

        def new
          # Render form to create live video
          # if peertube session no available, redirect to peertube-auth path
          redirect_to new_peertube_session_path unless current_peertube_user&.access_token_valid?

          # list available channels for user:
          # /api/v1/accounts/<peertube-username>/video-channels
          #
          # let them choose in which of these channels they want to create the live video
        end

        def create
          # https://docs.joinpeertube.org/api-rest-reference.html#operation/addLive
          # https://docs.joinpeertube.org/use-create-upload-video

          # POST to /videos/live
          #
          # "Authorization: Bearer #{current_peertube_user.access_token}"
          #
          # with params
          #
          # {
          #   channelId: "...",
          #   name: "...", name for video
          # }
          #
          # which returns something like
          # {
          #   "video": {
          #     "id": 42,
          #     "uuid": "9c9de5e8-0a1e-484a-b099-e80766180a6d",
          #     "shortUUID": "2y84q2MQUMWPbiEcxNXMgC"
          #   }
          # }
          #
          # https://docs.joinpeertube.org/api-rest-reference.html#operation/getLiveId
          #
          # then GET /api/v1/videos/live/<video-id>
          # where <video-id> is either id (integer) or UUIDv4 (string) or shortUUID (string)
          # to retrieve streaming data for video, i.e.:
          #
          #   {
          #     "rtmpUrl": "...",
          #     "rtmpsUrl": "...",
          #     "streamKey": "...",
          #     "saveReplay": true,
          #     "permanentLive": true
          # }
          #
          # and display those values to decidim user
        end
      end
    end
  end
end
