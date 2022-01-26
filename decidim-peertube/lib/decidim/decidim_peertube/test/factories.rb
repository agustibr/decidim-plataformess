# frozen_string_literal: true

FactoryBot.define do
  factory :peertube_user, class: "Decidim::DecidimPeertube::PeertubeUser" do
    user
    peertube_uid { Faker::Number.between(from: 1, to: 999) }
    peertube_account_id { Faker::Number.between(from: 1, to: 999) }
    peertube_username { Faker::Internet.username }

    access_token { Faker::Number.hexadecimal(digits: 32) }
    access_token_expires_at { Time.zone.now + 1.day }

    peertube_role { Faker::Number.between(from: 1, to: 4) }
    peertube_role_label { Faker::Lorem.word }

    video_channels do
      JSON.parse(File.read("spec/fixtures/files/peertube-user-channels.json"))
    end

    account do
      JSON.parse(File.read("spec/fixtures/files/peertube-user-account.json"))
    end

    data do
      JSON.parse(File.read("spec/fixtures/files/peertube-user-data.json"))
    end
  end

  factory :peertube_video, class: "Decidim::DecidimPeertube::PeertubeVideo" do
    component
    peertube_video_id { Faker::Alphanumeric.alpha }
    peertube_channel_id { Faker::Number.between(from: 1, to: 999) }

    video_url { "https://example.org/videos/watch/#{peertube_video_id}" }
    rtmp_url { "rtmp://example.org:1935/live/stream-key" }

    data do
      JSON.parse(File.read("spec/fixtures/files/peertube-video.json"))
    end
  end
end
