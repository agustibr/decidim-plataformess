# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    # A command with all the business logic when selecting a video for a component
    class SelectVideo < Rectify::Command
      # Public: Initializes the command.
      #
      # video - The peertube_video.
      def initialize(video)
        @video = video
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      #
      # Returns nothing.
      def call
        broadcast(:ok) if select_video!
      end

      private

      def select_video!
        current_component.update!(settings: { video_url: @video.video_url, title: @video.data["video_name"] })
      end
    end
  end
end
