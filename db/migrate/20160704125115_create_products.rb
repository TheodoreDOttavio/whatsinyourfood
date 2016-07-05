class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :upc
      t.string :brand_name
      t.string :item_name
      t.string :brand_id
      t.string :item_id
      t.string :item_description
      t.string :nf_ingredient_statement
      t.integer :nf_calories
      t.integer :nf_calories_from_fat
      t.integer :nf_total_fat
      t.integer :nf_saturated_fat
      t.integer :nf_trans_fatty_acid
      t.integer :nf_polyunsaturated_fat
      t.integer :nf_monounsaturated_fat
      t.integer :nf_cholesterol
      t.integer :nf_sodium
      t.integer :nf_total_carbohydrate
      t.integer :nf_dietary_fiber
      t.integer :nf_sugars
      t.integer :nf_protein
      t.integer :nf_vitamin_a_dv
      t.integer :nf_vitamin_c_dv
      t.integer :nf_calcium_dv
      t.integer :nf_iron_dv
      t.integer :nf_potassium
      t.integer :nf_servings_per_container
      t.decimal :nf_serving_size_qty
      t.string :nf_serving_size_unit
      t.decimal :nf_serving_weight_grams
      t.decimal :metric_qty
      t.string :metric_uom

      t.timestamps null: false
    end
  end
end
