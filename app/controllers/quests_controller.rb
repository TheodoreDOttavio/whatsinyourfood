class QuestsController < ApplicationController
  #before_action :set_quest, only: [:show, :edit, :update, :destroy]

  require 'unirest'

  def index
    #The API has a daily limit
    #  Going to use the Quest data to look for a new product by Name
    #  The API returns very few fields on a UPC lookup.

    #The first step on a new question will be to sneak in new products.
    #   because... this project is supposed to be about parsing JSON

    if rand(10) < 2 then
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
          end
        end

      end
  end #random

    #Select testfield
    case rand(12)
    when 0
      myfield = "nf_calories"
      @mytestquestion = "Which product has the most calories?"
      @mytest = "The most calories:"
    when 1
      myfield = "nf_calories_from_fat"
      @mytestquestion = "Which product has the most calories from fat?"
      @mytest = "The most calories from fat:"
    when 2
      myfield = "nf_total_fat"
      @mytestquestion = "Which product has the highest total fat content?"
      @mytest = "The highest total fat content:"
    when 3
      myfield = "nf_saturated_fat"
      @mytestquestion = "Which product has the most saturated fat?"
      @mytest = "The most saturated fat:"
    when 4
      myfield = "nf_cholesterol"
      @mytestquestion = "Which product has the highest amount of cholesterol?"
      @mytest = "The highest amount of cholesterol:"
    when 5
      myfield = "nf_sodium"
      @mytestquestion = "Which product has the most salt?"
      @mytest = "The most salt:"
    when 6
      myfield = "nf_protein"
      @mytestquestion = "Which product has the most protein?"
      @mytest = "The most protein:"
    when 7
      myfield = "nf_vitamin_a_dv"
      @mytestquestion = "Which product has the most vitamin A?"
      @mytest = "The most vitamin A:"
    when 8
      myfield = "nf_calcium_dv"
      @mytestquestion = "Which product has the most calcium?"
      @mytest = "The most calcium:"
    when 9
      myfield = "nf_iron_dv"
      @mytestquestion = "Which product has the most iron?"
      @mytest = "The most iron:"
    when 10
      myfield = "nf_total_carbohydrate"
      @mytestquestion = "Which product has the most total carbohydrates?"
      @mytest = "The most total carbohydrates:"
    when 11
      myfield = "nf_vitamin_c_dv"
      @mytestquestion = "Which product has the most vitamin C?"
      @mytest = "The most vitamin C:"
    end

    #Select 5 products for testing
    test = [{'test_condition' => 0}, {'test_condition' => 0}]
    loadcount = 4 #usually hits on one run... but this drops to loop and correct

    until test[test.count-1]['test_condition'] != test[test.count-2]['test_condition'] do
      #  Prepare up five brands to keep the products selected varied
      brands = Product.allbrands(myfield)
      brandlist = Hash.new
      for i in 0..loadcount
        pick = rand(brands.count)
        selectbrand = brands.delete_at(pick)
        brandlist[selectbrand] = rand(Product.brandcount(selectbrand))
      end

      brandlist.each do |brand, offsets|
        if @quizquestions.nil? then
          @quizquestions = Product.tester(brand, offsets, myfield)
        else
          @quizquestions += Product.tester(brand, offsets, myfield)
        end
      end

      #in the event that this is looping
      until @quizquestions.count < 6 do
        @quizquestions.delete_at(rand(4))
        loadcount = 2 #need new entries. drop this down to avoid repeating brands (which have similar items in different packages)
      end

      test = @quizquestions.sort_by { |e| e['test_condition'] }
    end

    @winnerid = test[test.count-1]['id']

=begin
    # Find a quirky username
    userreview = Unirest.get("https://acedev-project-name-generator-v1.p.mashape.com/with-number",
        headers:{"X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
          "Accept" => "application/json"})

    @user = userreview.body['spaced']

    #Feed the username into a sentiment analysis
    rating = Unirest.get "https://twinword-sentiment-analysis.p.mashape.com/analyze/",
      headers:{"X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
        "Content-Type" => "application/x-www-form-urlencoded",
        "Accept" => "application/json"},
      parameters:{
        "text" => @user}

     #use the sentiment analysys rating to generate 1-5 star rating
     score = (rating.body['score'] * 100).to_i
     score += 100
     @stars = 0
     @stars = score/40.0 if score != 0
     @stars = @stars.round + (rand(2)-1) #randomize the star rating to BS some personality
     @stars = 1 if @stars <= 0

     #Generate a comment by feed a text spinner a synonym string that matches the star rating
     case @stars
     when 1,2
       spinnerstring = "{{omg |wtf |WTF |seriously? |}}This {{question|one|test|}} {{is ridiculous|is stupid|is sad|is lame|is impossible|makes no sense|needs to go}}!"
     when 3
       spinnerstring = "{{meh |ummm... |whatever |nope. |who writes these? |}}{{This one was too easy|easy...|not so tough|:/|}}"
     when 4,5
       spinnerstring = "{{Lol |lol |LOL |HA |Ja |}}{{So true!|That was easy!|I got this!|good one|Rockin' it!|}}{{ :)| :-)| :p||}}"
     end

     response = Unirest.post "https://pozzad-text-spinner.p.mashape.com/textspinner/spin",
       headers:{"X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
         "Content-Type" => "application/x-www-form-urlencoded",
         "Accept" => "application/json"},
       parameters:{"variationsNum" => 1,
         "text" => spinnerstring}

     @comment = response.body["variations"][0]
=end
  end


  def check
    if params['iam'] == params['answer'] then
      @yourresults = "Winner!"
    else
      @yourresults = "Wrong Answer"
    end
    @mytest = params['mytest']
    @quizquestion = Product.find_by(id: params['iam'])
    @quizanswer = Product.find_by(id: params['answer'])
  end

end
