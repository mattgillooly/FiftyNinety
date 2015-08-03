class CreateSkirmishes < ActiveRecord::Migration
  def change
    create_table :skirmishes do |t|
      t.timestamp :starts_at
      t.string :title, null: false

      t.timestamps
    end

    add_index :skirmishes, [:starts_at]
  end
end
