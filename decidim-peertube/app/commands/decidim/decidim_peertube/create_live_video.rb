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
        update_live_video!

        broadcast(:ok)
      end

      private

      attr_reader :form, :access_token, :current_component, :peertube_video

      def create_live_video!
        params = {
          channel_id: form.channel_id,
          video_name: form.video_name,
          video_description: form.video_description,
          permanent_live: form.permanent_live,
          privacy: form.privacy,
          comments_enabled: form.comments_enabled,
          downloads_enabled: form.downloads_enabled
        }

        create_live_video_request = Decidim::DecidimPeertube::Api::CreateLiveVideoRequest.new(
          token: access_token,
          params: params
        )

        # TODO: handle possible error if response["video"].blank?
        uuid = create_live_video_request.response["video"]["uuid"]

        @peertube_video = PeertubeVideo.create!(
          component: current_component,
          peertube_video_id: uuid,
          video_url: Decidim::DecidimPeertube.url("videos/watch/#{uuid}"),
          data: params
        )
      end

      def update_live_video!
        live_video_info_request = Decidim::DecidimPeertube::Api::GetLiveVideoInfoRequest.new(
          token: access_token,
          video_id: peertube_video.peertube_video_id
        )

        # TODO: handle possible error if response["rtmpUrl"].blank?
        rtmp_url = [
          live_video_info_request.response["rtmpUrl"],
          live_video_info_request.response["streamKey"]
        ].join("/")

        @peertube_video.update!(rtmp_url: rtmp_url)
      end
    end
  end
end
