module ApplicationHelper
  def removecommas mytext
    mysample = mytext.split(",")
    myreturn = mysample.pop
    return myreturn.to_s + " " + mysample.join(",")
  end

  def newplayer
    obj = Player.new
    obj.save
    $userid = obj.id
    cookies[:user_id] = $userid
  end

  def gramstopercent(product_id)
    #nf_serving_weight_grams
    obj = Product.find(product_id)
    if obj['nf_serving_weight_grams'].to_i != 0 then
      mysize = obj['nf_serving_weight_grams'] + 0.000

      obj.update(:nf_calories_from_fat_pergram => obj['nf_calories_from_fat'].to_i/mysize) if obj['nf_calories_from_fat'].to_i != 0
      obj.update(:nf_calories_pergram => obj['nf_calories'].to_i/mysize ) if obj['nf_calories'].to_i != 0
      obj.update(:nf_total_fat_percent => (obj['nf_total_fat'].to_i/mysize)*100.00 ) if obj['nf_total_fat'].to_i != 0
      obj.update(:nf_saturated_fat_percent => (obj['nf_saturated_fat'].to_i/mysize)*100.00 ) if obj['nf_saturated_fat'].to_i != 0
      obj.update(:nf_trans_fatty_acid_percent => (obj['nf_trans_fatty_acid'].to_i/mysize)*100.00 ) if obj['nf_trans_fatty_acid'].to_i != 0
      obj.update(:nf_polyunsaturated_fat_percent => (obj['nf_polyunsaturated_fat'].to_i/mysize)*100.00 ) if obj['nf_polyunsaturated_fat'].to_i != 0
      obj.update(:nf_monounsaturated_fat_percent => (obj['nf_monounsaturated_fat'].to_i/mysize)*100.00 ) if obj['nf_monounsaturated_fat'].to_i != 0
      obj.update(:nf_cholesterol_percent => (obj['nf_cholesterol'].to_i/mysize)*100.00 ) if obj['nf_cholesterol'].to_i != 0
      obj.update(:nf_sodium_percent => ((obj['nf_sodium'].to_i/1000.000)/mysize)*100.00 ) if obj['nf_sodium'].to_i != 0
      obj.update(:nf_total_carbohydrate_percent => (obj['nf_total_carbohydrate'].to_i/mysize)*100.00 ) if obj['nf_total_carbohydrate'].to_i != 0
      obj.update(:nf_dietary_fiber_percent => (obj['nf_dietary_fiber'].to_i/mysize)*100.00 ) if obj['nf_dietary_fiber'].to_i != 0
      obj.update(:nf_sugars_percent => (obj['nf_sugars'].to_i/mysize)*100.00 ) if obj['nf_sugars'].to_i != 0
      obj.update(:nf_protein_percent => (obj['nf_protein'].to_i/mysize)*100.00 ) if obj['nf_protein'].to_i != 0
      
      obj.update(:nf_calories_from_fat_pergram => obj['nf_calories_from_fat_pergram'].round(3))
      obj.update(:nf_calories_pergram => obj['nf_calories_pergram'].round(3))
      obj.update(:nf_total_fat_percent => obj['nf_total_fat_percent'].round(3))
      obj.update(:nf_saturated_fat_percent => obj['nf_saturated_fat_percent'].round(3))
      obj.update(:nf_trans_fatty_acid_percent => obj['nf_trans_fatty_acid_percent'].round(3))
      obj.update(:nf_polyunsaturated_fat_percent => obj['nf_polyunsaturated_fat_percent'].round(3))
      obj.update(:nf_monounsaturated_fat_percent => obj['nf_monounsaturated_fat_percent'].round(3))
      obj.update(:nf_cholesterol_percent => obj['nf_cholesterol_percent'].round(3))
      obj.update(:nf_sodium_percent => obj['nf_sodium_percent'].round(5))
      obj.update(:nf_total_carbohydrate_percent => obj['nf_total_carbohydrate_percent'].round(3))
      obj.update(:nf_dietary_fiber_percent => obj['nf_dietary_fiber_percent'].round(3))
      obj.update(:nf_sugars_percent => obj['nf_sugars_percent'].round(3))
      obj.update(:nf_protein_percent => obj['nf_protein_percent'].round(3))
      
      obj.save(:validate => false)
    else
      #trash it...
      puts "deleting product id " + product_id.to_s
      Product.destroy(product_id)
    end

  end
end
