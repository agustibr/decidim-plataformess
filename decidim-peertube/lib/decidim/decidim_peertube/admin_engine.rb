# frozen_string_literal: true

require "decidim/decidim_peertube/awesome_helpers"

module Decidim
  module DecidimPeertube
    # This is the engine that runs on the public interface of `DecidimPeertube`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::DecidimPeertube::Admin

      paths["lib/tasks"] = nil

      routes do
      end

      initializer "decidim_decidim_peertube.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::DecidimPeertube::AdminEngine, at: "/admin/decidim_peertube", as: "decidim_admin_decidim_peertube"
        end
      end

      initializer "decidim_peertube.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.decidim_peertube", scope: "decidim.admin", default: "Peertube"),
                    decidim_admin_decidim_peertube.root_path,
                    icon_name: "video",
                    position: 7.5,
                    active: is_active_link?(decidim_admin_decidim_peertube.root_path, :inclusive),
                    if: defined?(current_user) && current_user&.read_attribute("admin")
        end
      end

      def load_seed
        nil
      end
    end
  end
end
