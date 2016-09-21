##
# Create a model ArenaService so we can save/update the locations of our arena services
class CreateArenaServices < ActiveRecord::Migration[5.0]
  def change
    create_table :arena_services do |t|
      t.string :address, null: false
      t.integer :port, null: false
      t.string :version

      t.timestamps
    end
  end
end
