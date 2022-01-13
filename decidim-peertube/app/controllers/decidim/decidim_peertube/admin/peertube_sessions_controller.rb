# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Admin
      class PeertubeSessionsController < Decidim::Admin::Components::BaseController
        include HasPeertubeSession

        def new
          # enforce_permission_to :create, :peertube_session

          @form = Decidim::DecidimPeertube::PeertubeSessionForm.new
        end

        def create
          # enforce_permission_to :create, :peertube_session

          @form = form(Decidim::DecidimPeertube::PeertubeSessionForm).from_params(params)

          Decidim::DecidimPeertube::Authenticate.call(@form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("peertube_sessions.create.success", scope: "decidim.decidim_peertube.admin")
              redirect_to root_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("peertube_sessions.create.invalid", scope: "decidim.decidim_peertube.admin")
              render action: "new"
            end
          end
        end

        def destroy
          # enforce_permission_to :destroy, :peertube_session

          current_peertube_user.destroy!

          flash.now[:notice] = I18n.t("peertube_sessions.destroy.success", scope: "decidim.decidim_peertube.admin")

          redirect_to root_path
        end
      end
    end
  end
end
