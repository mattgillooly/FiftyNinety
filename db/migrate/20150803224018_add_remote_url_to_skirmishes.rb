class AddRemoteUrlToSkirmishes < ActiveRecord::Migration
  def change
    add_column :skirmishes, :remote_url, :string, null: false
    add_index :skirmishes, [:remote_url], unique: true
  end
end
