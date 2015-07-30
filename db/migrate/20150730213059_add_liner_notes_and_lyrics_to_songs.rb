class AddLinerNotesAndLyricsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :liner_notes, :text
    add_column :songs, :lyrics, :text
  end
end
