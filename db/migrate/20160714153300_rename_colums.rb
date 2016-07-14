class RenameColums < ActiveRecord::Migration
  def change
    rename_column :products, :nf_total_fat_percent, :nf_total_fat_pergram
    rename_column :products, :nf_saturated_fat_percent, :nf_saturated_fat_pergram
    rename_column :products, :nf_trans_fatty_acid_percent, :nf_trans_fatty_acid_pergram
    rename_column :products, :nf_polyunsaturated_fat_percent, :nf_polyunsaturated_fat_pergram
    rename_column :products, :nf_monounsaturated_fat_percent, :nf_monounsaturated_fat_pergram
    rename_column :products, :nf_cholesterol_percent, :nf_cholesterol_pergram
    rename_column :products, :nf_sodium_percent, :nf_sodium_pergram
    rename_column :products, :nf_total_carbohydrate_percent, :nf_total_carbohydrate_pergram
    rename_column :products, :nf_dietary_fiber_percent, :nf_dietary_fiber_pergram
    rename_column :products, :nf_sugars_percent, :nf_sugars_pergram
    rename_column :products, :nf_protein_percent, :nf_protein_pergram
  end
end
