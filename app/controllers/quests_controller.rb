class QuestsController < ApplicationController
  #before_action :set_quest, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  def index
    $myheader = nil
    #The API has a daily limit
    #  Going to use the Quest data to look for a new product by Name
    #  The API returns very few fields on a UPC lookup.

    #The first step on a new question will be to sneak in new products.
    #   because... this project is supposed to be about parsing JSON

    runjsonimport = false
    #TODO the next two lines are commented out for development
    #runjsonimport = true if Product.count<200
    #runjsonimport = true if rand(10)<2
    runjsonimport = false if Product.count>5000

    if runjsonimport == true then
      loadnewproducts
    end

    #Select testfield
    questionpick = Topic.random[0]
    myfield = questionpick.test_field
    mytesttype = questionpick.qtype
    @mytestquestion = questionpick.question
    @mytest = questionpick.statement
    @mytopic = questionpick.id
    @mysubject = questionpick.name
    @mypoints = 5

    #Select 5 products for testing
    #  begin with a list of two, conflicting
    test = [{'test_condition' => 0}, {'test_condition' => 0}]

    until test[test.count-1]['test_condition'] != test[test.count-2]['test_condition'] do #makes sure the answer and next value are not identicle so one wins
      @quizquestions = Product.random(myfield)
      4.times do
        @quizquestions += Product.random(myfield)
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
    @mysubject = params['mysubject']
    @mypoints = params['mypoints'].to_i

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
      #getscore (playersuccesfield, playerfailurefield, :percent)
      obj.save

    end

    @quizquestion = Product.find_by(id: params['iam'])
    @quizanswer = Product.find_by(id: params['answer'])

    #TODO Throw a bonus? count Q answered.. or just show award for  Topic.name
    $myheader = 'award'
  end

end
