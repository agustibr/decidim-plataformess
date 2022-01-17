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
