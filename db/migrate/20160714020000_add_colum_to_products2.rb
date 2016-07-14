class AddColumToProducts2 < ActiveRecord::Migration
  def change
    add_column :products, :nf_vitamin_a_dv_pergram, :decimal, default: 0
    add_column :products, :nf_vitamin_c_dv_pergram, :decimal, default: 0
    add_column :products, :nf_calcium_dv_pergram, :decimal, default: 0
    add_column :products, :nf_iron_dv_pergram, :decimal, default: 0
    add_column :products, :nf_potassium_pergram, :decimal, default: 0
  end
end
