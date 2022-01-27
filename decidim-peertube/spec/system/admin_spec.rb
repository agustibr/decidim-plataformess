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
  let(:new_peertube_video_path) { Decidim::EngineRouter.admin_proxy(component).new_peertube_video_path(id: channel_id) }
  let(:destroy_peertube_session_path) { Decidim::EngineRouter.admin_proxy(component).peertube_sessions_path }
  let(:destroy_peertube_video_path) { Decidim::EngineRouter.admin_proxy(component).peertube_video_path(peertube_video) }
  let(:select_peertube_video_path) { Decidim::EngineRouter.admin_proxy(component).select_peertube_video_path(peertube_video) }

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

      expect(page).to have_link "Unlink account", href: destroy_peertube_session_path
      expect(page).to have_link "Change account", href: new_peertube_session_path

      expect(page).to have_content peertube_user.peertube_username
      expect(page).to have_content peertube_user.video_channels.first["displayName"]
    end
  end

  describe "with linked peertube account" do
    let!(:peertube_user) { create(:peertube_user, user: admin, access_token: access_token) }
    let(:access_token) { "4cc3s-t0k3n" }

    describe "create live videos" do
      let(:channel_id) { peertube_user.video_channels.first["id"] }

      let(:headers) do
        {
          "Authorization": "Bearer #{access_token}"
        }
      end

      let(:rtmp_url) { "rtmp://test-rtmp:8000/live" }
      let(:stream_key) { "a-stream-key" }
      let(:video_uuid) { "42-is-the-number" }

      let(:peertube_video) { Decidim::DecidimPeertube::PeertubeVideo.last }

      before do
        stub_api_request(method: :post, data: { "video" => { "uuid" => video_uuid } }, headers: headers)
        stub_api_request(method: :get, data: { "rtmpUrl" => rtmp_url, "streamKey" => stream_key }, headers: headers)
        visit new_peertube_video_path
      end

      it "allows creating a live video" do
        fill_in "peertube_video[video_name]", with: "A new video"
        fill_in "peertube_video[video_description]", with: "The video description is very short"
        select "Public", from: "peertube_video[privacy]"

        click_button "Create live video"

        expect(page).to have_content "The live video has been created successfully"
        expect(page).to have_content "A new video"
        expect(page).to have_link [rtmp_url, stream_key].join("/")

        expect(page).to have_content "Copy the Stream URL below"
        expect(page).to have_content "Don't share the Stream URL"

        expect(page).to have_link "Watch in Peertube", href: "https://example.org/videos/watch/#{video_uuid}"
        expect(page).to have_link "Embed this video in the component", href: select_peertube_video_path
        expect(page).to have_link "Delete", href: destroy_peertube_video_path
      end
    end

    describe "manage videos" do
      let!(:peertube_video) { create(:peertube_video, component: component, peertube_user: peertube_user) }

      it "allows to select a live video and embed it in public component" do
        visit main_component_path(component)
        expect(page.find("iframe")[:src]).not_to eq(peertube_video.video_url.gsub("watch", "embed"))

        visit manage_component_path(component)

        click_button "Embed this video in the component"

        visit main_component_path(component)
        expect(page.find("iframe")[:src]).to eq(peertube_video.video_url.gsub("watch", "embed"))
      end

      it "allows to delete a live video" do
        visit manage_component_path(component)

        expect(page).to have_content peertube_video.data["video_name"]

        click_button "Delete"

        expect(page).not_to have_content peertube_video.data["video_name"]
        expect(Decidim::DecidimPeertube::PeertubeVideo.find_by(id: peertube_video.id)).to be_blank
      end
    end

    it "allows changing peertube account" do
      click_link "Change account"

      expect(page).to have_content "Link Peertube account"
      expect(page).to have_content "Peertube username or email"
    end

    it "allows unlinking peertube account" do
      expect(page).to have_content(peertube_user.peertube_username)

      click_link "Unlink account"

      expect(page).not_to have_content(peertube_user.peertube_username)
      expect(Decidim::DecidimPeertube::PeertubeUser.find_by(id: peertube_user.id)).to be_blank
    end
  end
end
