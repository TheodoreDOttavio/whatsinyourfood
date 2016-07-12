module ApplicationHelper
  require 'unirest'
  
  
  def removecommas mytext
    mysample = mytext.split(",")
    myreturn = mysample.pop
    return myreturn.to_s + " " + mysample.join(",")
  end

  def newplayer
    obj = Player.new
    obj.save
    userid = obj.id
    cookies[:user_id] = userid
    return userid
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

  def loadnewproducts
      pick  = Quest.pickfreshone[0]
      myname = pick['name']
      myupc = pick['upc']
      mysearch = Unirest.get "https://nutritionix-api.p.mashape.com/v1_1/search/#{myname}?fields=upc%2Cbrand_name%2Citem_name%2Cbrand_id%2Citem_id%2Cupc%2Citem_description%2Cnf_ingredient_statement%2Cnf_calories%2Cnf_calories_from_fat%2Cnf_total_fat%2Cnf_saturated_fat%2Cnf_trans_fatty_acid%2Cnf_polyunsaturated_fat%2Cnf_monounsaturated_fat%2Cnf_cholesterol%2Cnf_sodium%2Cnf_total_carbohydrate%2Cnf_dietary_fiber%2Cnf_sugars%2Cnf_protein%2Cnf_vitamin_a_dv%2Cnf_vitamin_c_dv%2Cnf_calcium_dv%2Cnf_iron_dv%2Cnf_potassium%2Cnf_servings_per_container%2Cnf_serving_size_qty%2Cnf_serving_size_unit%2Cnf_serving_weight_grams%2Cmetric_qty%2Cmetric_uom",
        headers:{"X-Mashape-Key" => "e7ND2LrilQmshpZ9jDTEQbjStoBLp1LiRUSjsniR0pkkRebIAj",
          "Accept" => "application/json"}
      result = mysearch.body
      if result["error_code"] == true then
        #to do : refine this error check for limits vs. item not found!
        setsearch = Quest.find_by(upc: myupc)
        setsearch.update(is_searched: true)
        setsearch.update(is_associated: false)
      else
        #Remove the Quest item from future searches
        setsearch = Quest.find_by(upc: myupc)
        setsearch.update(is_searched: true)
        setsearch.update(is_associated: true)

        #Load all the found products into a local db
        resulthits = result['hits']
        resulthits.each do |oneproduct|
          #check if the product exists locally
          checkremoteid = oneproduct['fields']['item_id']
          puts checkremoteid
          if Product.find_by(item_id: checkremoteid).nil? then
            myfields = oneproduct['fields']
            fillerup = Product.new
            myfields.each do |key,value|
              fillerup.update(key => value)
            end
            gramstopercent(fillerup.id)
          end
        end

      end
      
  end
end
