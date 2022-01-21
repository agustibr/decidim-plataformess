# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    # This is the engine that runs on the public interface of `DecidimPeertube`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::DecidimPeertube::Admin

      paths["lib/tasks"] = nil

      routes do
        resources :peertube_videos, only: [:show, :edit, :update, :new, :create, :destroy] do
          post :select, on: :member
        end

        resources :peertube_sessions, only: [:new, :create] do
          delete :destroy, on: :collection
        end

        root to: "peertube_videos#edit"
      end

      def load_seed
        nil
      end
    end
  end
end
