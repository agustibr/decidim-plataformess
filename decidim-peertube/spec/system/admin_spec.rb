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
  let(:peertube_session_path) { Decidim::EngineRouter.admin_proxy(component).peertube_session_path }

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

  it "shows peertube videos section with 'empty' message" do
    expect(page).to have_content("There aren't any videos")
  end

  describe "link peertube account" do
    let(:username) { "test_username" }
    let(:password) { "test_password" }
    let(:http_method) { :post }
    let(:params) { { grant_type: "password", response_type: "code", username: username, password: password } }

    let(:access_token) { "4cc3s-t0k3n" }
    let(:data) { { "expires_in" => 80_000, "access_token" => access_token } }

    let(:headers) do
      {
        "Authorization": "Bearer #{access_token}"
      }
    end

    let(:peertube_uid) { Faker::Number.between(from: 1, to: 42) }
    let(:user_data) { JSON.parse(file_fixture("peertube-user-data.json").read).merge("id" => peertube_uid) }

    before do
      stub_api_request(method: :get, data: user_data, headers: headers)
      stub_api_request(method: :post, data: data, headers: {})
      click_link "Link Peertube account"
    end

    it "can submit peertube credentials form" do
      fill_in "peertube_session[username]",	with: username
      fill_in "peertube_session[password]",	with: password
      click_button "Link account"

      expect(page).to have_content "Your Peertube account has been linked"

      peertube_user = Decidim::DecidimPeertube::PeertubeUser.last
      expect(peertube_user.peertube_uid).to eq(peertube_uid)
      expect(peertube_user.access_token).to eq(access_token)

      expect(page).not_to have_link "Link Peertube account"
      expect(page).to have_content "Your Peertube account"

      expect(page).to have_link "Unlink account", href: peertube_session_path
      expect(page).to have_link "Change account", href: new_peertube_session_path
      
      expect(page).to have_content peertube_user.peertube_username
      expect(page).to have_content peertube_user.video_channels.first["displayName"]
    end
  end
end
