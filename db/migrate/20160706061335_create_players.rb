class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, default: "no name"
      #json hashs of {topic index => count}
      t.string :sucesses
      t.string :failures
      t.timestamps null: false
    end
  end
end
