##
# Create a record of a contest with a workflow.
class CreatePetContests < ActiveRecord::Migration[5.0]
  def change
    create_table :pet_contests do |t|
      t.string :contest_type, null: false
      t.string :workflow_state
      t.references :challenger, foreign_key: true
      t.references :challenged, foreign_key: true
      t.references :winner, foreign_key: true

      t.timestamps
    end
  end
end
