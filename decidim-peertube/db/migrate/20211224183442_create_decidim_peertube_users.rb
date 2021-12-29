# frozen_string_literal: true

class CreateDecidimPeertubeUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_peertube_users do |t|
      t.references :decidim_user, foreign_key: { to_table: :decidim_users }, index: { name: "index_decidim_peertube_users_on_user" }

      t.integer :peertube_uid
      t.integer :peertube_account_id

      t.string :peertube_username
      t.string :access_token
      t.datetime :access_token_expires_at

      t.integer :peertube_role
      t.string :peertube_role_label

      t.jsonb :account
      t.jsonb :video_channels
      t.jsonb :data

      t.timestamps
    end
  end
end

# {
#   "id": 123,
#   "username": "example",
#   "email": "example@platoniq.net",
#   "theme": "instance-default",
#   "pendingEmail": null,
#   "emailVerified": null,
#   "nsfwPolicy": "do_not_list",
#   "webTorrentEnabled": true,
#   "videosHistoryEnabled": true,
#   "autoPlayVideo": true,
#   "autoPlayNextVideo": false,
#   "autoPlayNextVideoPlaylist": true,
#   "videoLanguages": null,
#   "role": 1,
#   "roleLabel": "Moderator",
#   "videoQuota": -1,
#   "videoQuotaDaily": -1,
#   "noInstanceConfigWarningModal": false,
#   "noWelcomeModal": false,
#   "blocked": false,
#   "blockedReason": null,
#   "account": {
#     "url": "https://peertube.hostname.org/accounts/example",
#     "name": "example",
#     "host": "peertube.hostname.org",
#     "avatar": null,
#     "id": 4276,
#     "hostRedundancyAllowed": false,
#     "followingCount": 0,
#     "followersCount": 0,
#     "createdAt": "2021-12-20T16:12:55.806Z",
#     "updatedAt": "2021-12-20T16:12:55.806Z",
#     "displayName": "example",
#     "description": null,
#     "userId": 123
#   },
#   "notificationSettings": {
#     "newCommentOnMyVideo": 1,
#     "newVideoFromSubscription": 1,
#     "abuseAsModerator": 3,
#     "videoAutoBlacklistAsModerator": 3,
#     "blacklistOnMyVideo": 3,
#     "myVideoPublished": 1,
#     "myVideoImportFinished": 1,
#     "newUserRegistration": 1,
#     "commentMention": 1,
#     "newFollow": 1,
#     "newInstanceFollower": 1,
#     "autoInstanceFollowing": 1,
#     "abuseNewMessage": 3,
#     "abuseStateChange": 3
#   },
#   "videoChannels": [
#     {
#       "url": "https://peertube.hostname.org/video-channels/example_channel",
#       "name": "example_channel",
#       "host": "peertube.hostname.org",
#       "avatar": null,
#       "id": 16,
#       "hostRedundancyAllowed": false,
#       "followingCount": 0,
#       "followersCount": 0,
#       "createdAt": "2021-12-20T16:12:55.809Z",
#       "updatedAt": "2021-12-20T16:12:55.809Z",
#       "displayName": "example_channel",
#       "description": null,
#       "support": null,
#       "isLocal": true
#     }
#   ],
#   "createdAt": "2021-12-20T16:12:55.731Z",
#   "pluginAuth": null,
#   "lastLoginDate": "2021-12-24T15:55:31.912Z",
#   "specialPlaylists": [
#     {
#       "id": 16,
#       "name": "Watch later",
#       "type": 2
#     }
#   ]
# }
