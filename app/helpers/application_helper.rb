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

  def gramstopergram(product_id)
    #nf_serving_weight_grams
    fieldlist = {
      :nf_calories_from_fat_pergram => "nf_calories_from_fat",
      :nf_calories_pergram => "nf_calories",
      :nf_total_fat_pergram => "nf_total_fat",
      :nf_saturated_fat_pergram => "nf_saturated_fat",
      :nf_trans_fatty_acid_pergram => "nf_trans_fatty_acid",
      :nf_polyunsaturated_fat_pergram => "nf_polyunsaturated_fat",
      :nf_monounsaturated_fat_pergram => "nf_monounsaturated_fat",
      :nf_cholesterol_pergram => "nf_cholesterol",
      :nf_total_carbohydrate_pergram => "nf_total_carbohydrate",
      :nf_dietary_fiber_pergram => "nf_dietary_fiber",
      :nf_sugars_pergram => "nf_sugars",
      :nf_protein_pergram => "nf_protein",
      :nf_vitamin_a_dv_pergram => "nf_vitamin_a_dv",
      :nf_vitamin_c_dv_pergram => "nf_vitamin_c_dv",
      :nf_calcium_dv_pergram => "nf_calcium_dv",
      :nf_iron_dv_pergram => "nf_iron_dv",
      :nf_potassium_pergram => "nf_potassium"
    }

    obj = Product.find(product_id)
    if obj['nf_serving_weight_grams'].to_i != 0 then
      mysize = obj['nf_serving_weight_grams'] + 0.000

      fieldlist.each do |fkey, fvalue|
        if obj[fvalue].to_i != 0 then
          storevalue = obj[fvalue].to_i/mysize
          storevalue = storevalue.round(4)
          obj.update(fkey => storevalue)
        end
      end

      #salt is in milligrams .. convert it to grams and extend it to 6 decimals instead of 4
      storevalue = 0
      storevalue = (obj['nf_sodium'].to_i/1000.000)/mysize if obj['nf_sodium'].to_i != 0
      storevalue = storevalue.round(6)
      obj.update(:nf_sodium_pergram => storevalue)

      obj.save(:validate => false)
    else
      #trash it bcause there is no serving size in grams!
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

    if mysearch.body['total_hits'].nil? then #error check
      setsearch = Quest.find_by(upc: myupc)
      setsearch.update(is_searched: true)
      setsearch.update(is_associated: false)
    else
      result = mysearch.body
      #Remove the Quest item from future searches
      setsearch = Quest.find_by(upc: myupc)
      setsearch.update(is_searched: true)
      setsearch.update(is_associated: true)

      #Load all the found products into a local db
      resulthits = result['hits']
      resulthits.each do |oneproduct|
        #check if the product exists locally
        checkremoteid = oneproduct['fields']['item_id']
        #puts checkremoteid
        if Product.find_by(item_id: checkremoteid).nil? then
          myfields = oneproduct['fields']
          fillerup = Product.new
          myfields.each do |key,value|
            fillerup.update(key => value)
          end
          gramstopergram(fillerup.id)
        end
      end
    end #error check

  end

  def getscore (playersuccesfield, playerfailurefield, myparam)
    stot = 0
    if playersuccesfield.nil? == false then
      answ = JSON.parse!(playersuccesfield)
      answ.each do |key,val|
        stot += val.to_i
      end
    end

    ftot = 0
    if playerfailurefield.nil? == false then
      answ = JSON.parse!(playerfailurefield)
      answ.each do |key,val|
        ftot += val.to_i
      end
    end

    spercent = 0
    spercent = (stot/(stot+ftot))*100 if stot != 0

    #myparam symbols:
    score = {:total_questions => ftot + stot,
      :total => ftot + stot,
      :percent => spercent.round(0)}

    return (score[myparam])
  end


end
