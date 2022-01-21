# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    # A command with the business logic for linking a Peertube account with a decidim user
    class Authenticate < Rectify::Command
      # Public: Initializes the command.
      #
      # form         - A form object with the params.
      # current_user - The current user.
      def initialize(form, current_user)
        @form = form
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the follow.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        authenticate!
        update_user!

        broadcast(:ok)
      end

      private

      attr_reader :form, :current_user, :peertube_user

      def authenticate!
        authentication_request = Decidim::DecidimPeertube::Api::AuthenticationRequest.new(username: form.username, password: form.password)

        @peertube_user = Decidim::DecidimPeertube::PeertubeUser.find_or_create_by(user: current_user)

        @peertube_user.update!(
          peertube_username: form.username,
          access_token: authentication_request.response["access_token"],
          access_token_expires_at: Time.zone.now + authentication_request.response["expires_in"].to_i
        )
      end

      def update_user!
        user_info_request = Decidim::DecidimPeertube::Api::GetUserInfoRequest.new(token: @peertube_user.access_token)

        @peertube_user.update!(
          peertube_uid: user_info_request.response["id"],
          peertube_account_id: user_info_request.response["account"]["id"],
          peertube_username: user_info_request.response["username"],
          peertube_role: user_info_request.response["role"],
          peertube_role_label: user_info_request.response["roleLabel"],
          account: user_info_request.response["account"],
          video_channels: user_info_request.response["videoChannels"],
          data: user_info_request.response
        )
      end
    end
  end
end
