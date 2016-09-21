##
# Create our first draft model of pets
class CreatePets < ActiveRecord::Migration[5.0]
  def change
    create_table :pets do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.string :pet_type, null: false
      t.string :workflow_state
      t.integer :strength, null: false
      t.integer :wit, null: false
      t.integer :senses, null: false
      t.integer :agility, null: false
      t.integer :experience, null: false

      t.timestamps
    end
  end
end
