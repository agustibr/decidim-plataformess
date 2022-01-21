# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    # A command with the business logic for creting a live video in Peertube
    class CreateLiveVideo < Rectify::Command
      # Public: Initializes the command.
      #
      # form         - A form object with the params.
      # current_peertube_user - The peertube_user associated with the current Decidim user.
      # current_component - The current component.
      def initialize(form, current_peertube_user, current_component)
        @form = form
        @current_peertube_user = current_peertube_user
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

      attr_reader :form, :current_peertube_user, :current_component, :peertube_video

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
          token: current_peertube_user.access_token,
          params: params
        )

        # TODO: handle possible error if response["video"].blank?
        uuid = create_live_video_request.response["video"]["uuid"]

        @peertube_video = PeertubeVideo.create!(
          peertube_user: current_peertube_user,
          component: current_component,
          peertube_video_id: uuid,
          video_url: Decidim::DecidimPeertube.url("videos/watch/#{uuid}"),
          data: params
        )

        current_component.update!(settings: { title: form.video_name, video_url: @peertube_video.video_url })
      end

      def update_live_video!
        live_video_info_request = Decidim::DecidimPeertube::Api::GetLiveVideoInfoRequest.new(
          token: current_peertube_user.access_token,
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
