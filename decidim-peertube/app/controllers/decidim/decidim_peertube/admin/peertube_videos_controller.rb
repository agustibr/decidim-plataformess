# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Admin
      class PeertubeVideosController < Decidim::Admin::Components::BaseController
        include HasPeertubeSession
        helper PeertubeHelper

        helper_method :peertube_videos

        before_action :check_peertube_session, only: [:new, :create]

        def show
          # enforce_permission_to :show, :peertube_video
        end

        def edit
          # enforce_permission_to :edit, :peertube_video
        end

        def new
          # enforce_permission_to :create, :peertube_video

          @form = Decidim::DecidimPeertube::PeertubeVideoForm.new
        end

        def create
          # enforce_permission_to :create, :peertube_video

          @form = form(Decidim::DecidimPeertube::PeertubeVideoForm).from_params(params)

          Decidim::DecidimPeertube::CreateLiveVideo.call(@form, current_peertube_user, current_component) do
            on(:ok) do
              flash[:notice] = I18n.t("peertube_videos.create.success", scope: "decidim.decidim_peertube.admin")
              redirect_to root_path # change to edit_component_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("peertube_videos.create.invalid", scope: "decidim.decidim_peertube.admin")
              render action: "new"
            end
          end
        end

        private

        def peertube_videos
          @peertube_videos ||= Decidim::DecidimPeertube::PeertubeVideo.where(component: current_component)
        end
      end
    end
  end
end
