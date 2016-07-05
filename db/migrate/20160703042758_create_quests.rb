class CreateQuests < ActiveRecord::Migration
  #prepared by Ingesting data from the national database:
  #  https://ndb.nal.usda.gov/ndb/foods?format=&count=&max=1000&order=desc
  #with rake db:seed

  def change
    create_table :quests do |t|
      t.string :upc, null: false #json queires use a string, so skip storing this as an integer
      t.string :manufacturer
      t.string :name
      t.string :size
      t.boolean :is_associated, :default => false #Has information been found?
      t.boolean :is_searched, :default => false #has been checked in external JSON API
      t.timestamps null: false
    end
  end
end