# frozen_string_literal: true

require "spec_helper"
require "decidim/decidim_peertube/test/shared_contexts"

describe "Visit the admin page", type: :system do
  include_context "with stubs example api"
  include_context "with an embed peertube_video component"

  let(:organization) { create :organization }
  let!(:admin) { create(:user, :admin, :confirmed, organization: organization) }

  let(:edit_component_path) { Decidim::EngineRouter.admin_proxy(component.participatory_space).edit_component_path(component.id) }
  let(:new_peertube_session_path) { Decidim::EngineRouter.admin_proxy(component).new_peertube_session_path }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user

    visit manage_component_path(component)
  end

  it "has three buttons" do
    expect(page).to have_link("Embed a Peertube video", href: edit_component_path)
    expect(page).to have_link("Visit component", href: main_component_path(component))
    expect(page).to have_link("Link Peertube account", href: new_peertube_session_path)
  end
end
