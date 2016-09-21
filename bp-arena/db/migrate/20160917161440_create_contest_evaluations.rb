class CreateContestEvaluations < ActiveRecord::Migration[5.0]
  def change
    create_table :contest_evaluations do |t|
      t.integer :contest_id, null: false
      t.string :contest_type, null: false
      t.string :callback_host, null: false
      t.string :challenger, null: false
      t.string :challenged, null: false

      t.timestamps null: false
    end
  end
end
