# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    # A command with all the business logic when destroying a video
    class DestroyVideo < Rectify::Command
      def initialize(video, peertube_user)
        @video = video
        @peertube_user = peertube_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        destroy_video!
        broadcast(:ok)
      end

      private

      def destroy_video!
        Decidim.traceability.perform_action!(
          :delete,
          @video,
          @peertube_user.user
        ) do
          @video.destroy!
        end

        Decidim::DecidimPeertube::Api::DeleteVideoRequest.new(token: @peertube_user.access_token, id: @video.peertube_video_id)
      end
    end
  end
end
