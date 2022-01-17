# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    # A command with the business logic for creting a live video in Peertube
    class CreateLiveVideo < Rectify::Command
      # Public: Initializes the command.
      #
      # form         - A form object with the params.
      # access_token - The Peertube account access_token for the current user.
      # current_component - The current component.
      def initialize(form, access_token, current_component)
        @form = form
        @access_token = access_token
        @current_component = current_component
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the follow.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        create_live_video!

        broadcast(:ok)
      end

      private

      attr_reader :form, :access_token, :current_component

      def create_live_video!
        create_live_video_request = Decidim::DecidimPeertube::Api::CreateLiveVideoRequest.new(
          token: access_token,
          channel_id: form.channel_id,
          video_name: form.video_name,
          video_description: form.video_description
        )

        uuid = create_live_video_request.response["video"]["uuid"]

        live_video_info_request = Decidim::DecidimPeertube::Api::GetLiveVideoInfoRequest.new(
          token: access_token,
          video_id: uuid
        )

        settings = current_component.settings
        settings[:video_url] = Decidim::DecidimPeertube.url("videos/watch/#{uuid}")
        
        rtmp_url = [
          live_video_info_request.response["rtmpUrl"],
          live_video_info_request.response["streamKey"]
        ].join("/")
        
        settings[:rtmp_url] = rtmp_url

        current_component.update!(settings: settings)
      end
    end
  end
end
