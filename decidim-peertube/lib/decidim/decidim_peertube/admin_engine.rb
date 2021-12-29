# frozen_string_literal: true

require "decidim/decidim_peertube/awesome_helpers"

module Decidim
  module DecidimPeertube
    # This is the engine that runs on the public interface of `DecidimPeertube`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::DecidimPeertube::Admin

      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        resources :constraints
        resources :menu_hacks, except: [:show]
        resources :config, param: :var, only: [:show, :update]
        resources :scoped_styles, param: :var, only: [:create, :destroy]
        resources :scoped_admins, param: :var, only: [:create, :destroy]
        get :users, to: "config#users"
        get :checks, to: "checks#index"
        root to: "config#show", var: :editors
      end

      initializer "decidim_admin_awesome.assets" do |app|
        app.config.assets.precompile += if version_prefix == "v0.23"
                                          %w(legacy_decidim_admin_decidim_peertube_manifest.js decidim_admin_decidim_peertube_manifest.css)
                                        else
                                          %w(decidim_admin_decidim_peertube_manifest.js decidim_admin_decidim_peertube_manifest.css)
                                        end
      end

      initializer "decidim_decidim_peertube.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::DecidimPeertube::AdminEngine, at: "/admin/decidim_peertube", as: "decidim_admin_decidim_peertube"
        end
      end

      initializer "decidim_peertube.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.decidim_peertube", scope: "decidim.admin", default: "Decidim Awesome"),
                    decidim_admin_decidim_peertube.config_path(:editors),
                    icon_name: "fire",
                    position: 7.5,
                    active: is_active_link?(decidim_admin_decidim_peertube.config_path(:editors), :inclusive),
                    if: defined?(current_user) && current_user&.read_attribute("admin")
        end
      end

      def load_seed
        nil
      end
    end
  end
end
