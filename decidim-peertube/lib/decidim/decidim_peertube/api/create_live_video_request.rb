# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Api
      class CreateLiveVideoRequest < Request
        # https://docs.joinpeertube.org/api-rest-reference.html#operation/addLive
        # https://docs.joinpeertube.org/use-create-upload-video

        def initialize(token:, params:)
          params = {
            channelId: params[:channel_id],
            name: params[:video_name],
            description: params[:video_description],
            privacy: params[:privacy],
            permanentLive: params[:permanent_live],
            saveReplay: !params[:permanent_live],
            commentsEnabled: params[:comments_enabled],
            downloadEnabled: params[:downloads_enabled]
            # FUTURE tags: params[:tags],
            # FUTURE previewfile: params[:preview_file]
            # FUTURE thumbnailfile: params[:thumbnail_file]
          }.compact

          post_authenticated(
            token,
            "videos/live",
            params
          )
        end
      end
    end
  end
end
