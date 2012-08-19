class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :player
      t.boolean :victory, default: nil

      t.timestamps
    end
    add_index :games, :victory
  end
end
