class QuestsController < ApplicationController
  #before_action :set_quest, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  def index
    $myheader = nil
    #The API has a daily limit
    #  Uses the Quest data to look for a new product by Name
    #  The API returns very few fields on a UPC lookup.

    #The first step on a new question will be to sneak in new products.
    runjsonimport = false
    #TODO the next two lines are commented out for development
    #runjsonimport = true if Product.count<200
    #runjsonimport = true if rand(10)<2
    runjsonimport = false if Product.count>5000

    if runjsonimport == true then
      loadnewproducts
    end

    #Take a look at the user and select topic/difficulty
    if $userid.nil? then
      #Select testfield
      questionpick = Topic.random[0]
      questiondifficulty = 0
    else
      #Select testfield and level from user datum
      questionpick = Topic.random[0]
      #check level by topic
      questiondifficulty = 0 #0,1,2
    end

    myfield = questionpick.test_field
    mytesttype = questionpick.qtype
    @mytestquestion = questionpick.question
    @mytest = questionpick.statement
    @mytopic = questionpick.id
    @mysubject = questionpick.name

    checkmaxvalue = (Product.pergrammax(myfield)[0].top_value).to_f
    case questiondifficulty
    when 1
      #medium difficulty - All random
      @mypoints = 10
      if mytesttype == false then
        testmin = 0.0001
        testmax = checkmaxvalue * 0.80000
      else
        testmin = checkmaxvalue * 0.20000
        testmax = checkmaxvalue + 1
      end

      #select uniq winner and four questions
      newquizquestion = []
      while newquizquestion == [] do
        newquizquestion = Product.random(myfield, testmin, testmax)
      end
      @quizquestions = newquizquestion
      @winnerid = @quizquestions[0]['id']
      selectedids = @winnerid.to_s
      if mytesttype == false then # note mytesttype == false for least
        ansmin = @quizquestions[0][myfield] + 0.0001
        ansmax = checkmaxvalue + 1
      else
        ansmin = 0.0001
        ansmax = @quizquestions[0][myfield] - 0.0001
      end
      newquizquestion = []

      4.times do
        while newquizquestion == [] do
          newquizquestion = Product.random(myfield, ansmin, ansmax, selectedids)
        end
        selectedids += " and id is not " + newquizquestion[0]['id'].to_s
        @quizquestions += newquizquestion
        newquizquestion = []
      end

    when 2
      #Challenging, select from a tight range of values
      @mypoints = 20
      #select uniq winner and four questions
      newquizquestion = []
      while newquizquestion == [] do
        newquizquestion = Product.random(myfield)
      end
      @quizquestions = newquizquestion
      @winnerid = @quizquestions[0]['id']
      selectedids = @winnerid.to_s
      if mytesttype == false then # note mytesttype == false for least
        ansmin = @quizquestions[0][myfield] + 0.0001
        ansmax = @quizquestions[0][myfield] + (checkmaxvalue * 0.30000)
      else
        ansmin = @quizquestions[0][myfield] - (checkmaxvalue * 0.30000)
        ansmax = @quizquestions[0][myfield] - 0.0001
      end
      newquizquestion = []

      4.times do
        while newquizquestion == [] do
          newquizquestion = Product.random(myfield, ansmin, ansmax, selectedids)
        end
        selectedids += " and id is not " + newquizquestion[0]['id'].to_s
        @quizquestions += newquizquestion
        newquizquestion = []
      end

    else
      #the easiest, Answer from the end 30% of value, wrong Answres from the other 60%
      @mypoints = 5
      # note mytesttype == false for least
      if mytesttype == false then
        testmin = 0.0001
        testmax = checkmaxvalue * 0.30000
        ansmin = checkmaxvalue * 0.30000
        ansmax = checkmaxvalue + 1
      else
        testmin = checkmaxvalue * 0.60000
        testmax = checkmaxvalue + 1
        ansmin = 0.0001
        ansmax = checkmaxvalue * 0.60000
      end

      #select uniq winner and four questions
      newquizquestion = []
      while newquizquestion == [] do
        newquizquestion = Product.random(myfield, testmin, testmax)
      end
      @quizquestions = newquizquestion
      @winnerid = @quizquestions[0]['id']
      selectedids = @winnerid.to_s
      newquizquestion = []

      4.times do
        while newquizquestion == [] do
          newquizquestion = Product.random(myfield, ansmin, ansmax, selectedids)
        end
        selectedids += " and id is not " + newquizquestion[0]['id'].to_s
        @quizquestions += newquizquestion
        newquizquestion = []
      end
    end

    @quizquestions.shuffle!

    # #Select 5 products for testing
    # #  begin with a list of two, conflicting
    # test = [{'test_condition' => 0}, {'test_condition' => 0}]
    #
    # #make sure the answer and next value are not identicle with until loop so one wins
    # until test[test.count-1]['test_condition'] != test[test.count-2]['test_condition'] do
    #   @quizquestions = Product.random(myfield, testmin, testmax)
    #   #while @quizquestions.count <= 5 do
    #   4.times do
    #     @quizquestions += Product.random(myfield, ansmin, ansmax)
    #   end
    #   test = @quizquestions.sort_by { |e| e['test_condition'] }
    #   test = test.reverse if mytesttype == false
    # end
    #
    # @winnerid = test[test.count-1]['id']
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
    @mysubject = params['mysubject']
    @mypoints = params['mypoints'].to_i

    #evaluate bonuses
    buttontype = params['option'].first[0]
    @mypoints *= 3 if buttontype == "cherry"
    @mypoints *= 2 if buttontype == "grain"

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

      if playerhash[@mysubject.to_s].nil? then
        playerhash[@mysubject.to_s] = 1
      else
        playerhash[@mysubject.to_s] = playerhash[@mysubject.to_s] + 1
      end
      obj.sucesses = JSON.fast_generate(playerhash)

      #add points
      playerhash = obj.scores
      if playerhash.nil? or playerhash == "" then
        playerhash = {}
      else
        playerhash = JSON.parse!(obj.scores)
      end

      if playerhash[@mysubject.to_s].nil? then
        playerhash[@mysubject.to_s] = @mypoints
      else
        playerhash[@mysubject.to_s] = playerhash[@mysubject.to_s] + @mypoints
      end
      obj.scores = JSON.fast_generate(playerhash)
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
      if playerhash[@mysubject.to_s].nil? then
        playerhash[@mysubject.to_s] = 1
      else
        playerhash[@mysubject.to_s] = playerhash[@mysubject.to_s] + 1
      end
      obj.failures = JSON.fast_generate(playerhash)
      obj.save

    end

    @quizquestion = Product.find_by(id: params['iam'])
    @quizanswer = Product.find_by(id: params['answer'])

    #TODO Throw a bonus? count Q answered.. or just show award for  Topic.name
    $myheader = 'award'
  end

end
