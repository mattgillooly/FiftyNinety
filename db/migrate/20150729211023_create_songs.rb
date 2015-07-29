class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :remote_id, null: false
      t.string :title, null: false
      t.string :username, null: false
      t.string :user_href, null: false
      t.boolean :has_demo, null: false
      t.string :demo_href
      t.timestamp :posted_date, null: false

      t.timestamps
    end

    add_index :songs, [:remote_id], :unique => true
    add_index :songs, [:user_href, :posted_date]
  end
end
