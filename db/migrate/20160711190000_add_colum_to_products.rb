class AddColumToProducts < ActiveRecord::Migration
  def change
    add_column :products, :nf_total_fat_percent, :decimal, default: 0
    add_column :products, :nf_saturated_fat_percent, :decimal, default: 0
    add_column :products, :nf_trans_fatty_acid_percent, :decimal, default: 0
    add_column :products, :nf_polyunsaturated_fat_percent, :decimal, default: 0
    add_column :products, :nf_monounsaturated_fat_percent, :decimal, default: 0
    add_column :products, :nf_cholesterol_percent, :decimal, default: 0
    add_column :products, :nf_sodium_percent, :decimal, default: 0
    add_column :products, :nf_total_carbohydrate_percent, :decimal, default: 0
    add_column :products, :nf_dietary_fiber_percent, :decimal, default: 0
    add_column :products, :nf_sugars_percent, :decimal, default: 0
    add_column :products, :nf_protein_percent, :decimal, default: 0
  end
end
