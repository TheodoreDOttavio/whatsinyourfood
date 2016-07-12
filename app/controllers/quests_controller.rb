class QuestsController < ApplicationController
  #before_action :set_quest, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  def index
    #The API has a daily limit
    #  Going to use the Quest data to look for a new product by Name
    #  The API returns very few fields on a UPC lookup.

    #The first step on a new question will be to sneak in new products.
    #   because... this project is supposed to be about parsing JSON

    runjsonimport = false
    runjsonimport = true if Product.count<200
    runjsonimport = true if rand(10)<2
    runjsonimport = false if Product.count>5000

    if runjsonimport == true then
      loadnewproducts
    end

    #Select testfield
    questionpick = Topic.random[0]
    puts questionpick.inspect
    myfield = questionpick.test_field
    mytesttype = questionpick.qtype
    @mytestquestion = questionpick.question
    @mytest = questionpick.statement
    @mytopic = questionpick.id



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
      test = test.reverse if mytesttype == false
    end

    @winnerid = test[test.count-1]['id']
  end


  def check
    #check/set user from cookie
    if $userid.nil? then
      $userid = cookies[:user_id]
      if $userid.nil? then
        $userid = newplayer
      end
    end

    obj = Player.find_by(id: $userid.to_i)
    #in the event that the Web-app data is cleared but a cookie remains:
    if obj.nil? then
      $userid = newplayer
      obj = Player.find_by(id: $userid.to_i)
    end

    @mytest = params['mytest']
    @mytopic = params['mytopic']

    if params['iam'] == params['answer'] then
      @yourresults = "Winner!"
      @mystyle = "background-color: #9fde89;" #subdued green
      Topic.update_counters @mytopic, sucesses: 1

      playerhash = obj.sucesses
      if playerhash.nil? or playerhash == "" then
        playerhash = {}
      else
        playerhash = JSON.parse!(obj.sucesses)
      end

      if playerhash[@mytopic.to_s].nil? then
        playerhash[@mytopic.to_s] = 1
      else
        playerhash[@mytopic.to_s] = playerhash[@mytopic.to_s] + 1
      end
      obj.sucesses = JSON.fast_generate(playerhash)
      obj.save

    else
      @yourresults = "Incorrect."
      @mystyle = "background-color: #de8989;" #subdued red
      Topic.update_counters @mytopic, failures: 1

      playerhash = obj.failures
      if playerhash.nil? or playerhash == "" then
        playerhash = {}
      else
        playerhash = JSON.parse!(obj.failures)
      end
      if playerhash[@mytopic.to_s].nil? then
        playerhash[@mytopic.to_s] = 1
      else
        playerhash[@mytopic.to_s] = playerhash[@mytopic.to_s] + 1
      end
      obj.failures = JSON.fast_generate(playerhash)
      obj.save

    end

    @quizquestion = Product.find_by(id: params['iam'])
    @quizanswer = Product.find_by(id: params['answer'])
  end

end
