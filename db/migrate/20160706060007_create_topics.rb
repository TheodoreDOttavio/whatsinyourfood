class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :question
      t.string :statement
      t.boolean :qtype           #true for hiest, false for absence of
      t.string :test_field
      #global successes and failures
      t.integer :sucesses
      t.integer :failures
      t.timestamps null: false
    end
  end
end
