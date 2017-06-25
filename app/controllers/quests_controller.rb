class QuestsController < ApplicationController
  #before_action :set_quest, only: [:show, :edit, :update, :destroy]

  include ApplicationHelper

  def index
    #The API has a daily limit
    #  Uses the Quest data to look for a new product by Name
    #  The API returns very few fields on a UPC lookup.

    #The first step on a new question will be to sneak in new products.
    runjsonimport = false
    runjsonimport = true if Product.count<200
    runjsonimport = true if rand(10)<2
    runjsonimport = false if Product.count>5000

    if runjsonimport == true then
      loadnewproducts if !Rails.env.development?
    end

    establishplayerobject

    if @playerobject.subject == "" or @playerobject.subject == nil then
      questionpick = Topic.random[0]
      @playersubject = ""
    else
      @playersubject = @playerobject.subject
      questionpick = Topic.randomquestion(@playersubject.to_s)[0]
    end

    scores = JSON.parse!(@playerobject.scores)
    @myscore = scores[questionpick.name].to_i

    #check level by topic
    questiondifficulty = 2
    questiondifficulty = 1 if @myscore < 500
    questiondifficulty = 0 if @myscore < 100

    myfield = questionpick.test_field
    mytesttype = questionpick.qtype
    @mytestquestion = questionpick.question
    @mytest = questionpick.statement
    @mytopic = questionpick.id
    @mysubject = questionpick.name

    checkmaxvalue = (Product.pergrammax(myfield)[0].top_value).to_f
    case questiondifficulty
    when 1
      @mypoints = 10
      buildquestion_med(myfield, mytesttype, checkmaxvalue)
    when 2
      @mypoints = 20
      buildquestion_hard(myfield, mytesttype, checkmaxvalue)
    else
      @mypoints = 5
      buildquestion_easy(myfield, mytesttype, checkmaxvalue)
    end

    @quizquestions.shuffle!

    #show any bonuses for answering questions
    bonuses = @playerobject.bonuses if !@playerobject.nil?
    @mybonus = []
    if !bonuses.nil? or bonuses != "" then
      bonuses = JSON.parse!(@playerobject.bonuses)
      bonuses.each do |k,v|
        if k != "event" and v > 0 then
          @mybonus.push(k)
          #Reloading questions deteriorates the options for bonus things
          flash[k] = "Last chance to use the #{k}!" if bonuses[k] == 1
          bonuses[k] -= 1
        end
      end
    end
    @playerobject.bonuses = JSON.fast_generate(bonuses)
    @playerobject.save
  end


  def setsubject
    establishplayerobject
    if !@playerobject.nil? then
      @playerobject.subject = params['mysubject']
      @playerobject.save
    end
    redirect_to quests_path
  end


  #TODO a subpage function to request login when a ribbon is won

  def check
    #selection to lock in subject, or randomize it
    @subjectlist = Topic.subjectnames

    establishplayerobject

    @mytest = params['mytest']
    @mytopic = params['mytopic']
    @mysubject = params['mysubject']
    @mypoints = params['mypoints'].to_i

    #Baiting the player with bonuses
    #  track how many q's answered since last award and randomly ad award
    #  used further on in the function... going a little procedural oldschool here...
    bonuses = @playerobject.bonuses
    if bonuses == "{}" then
      bonuses = {"event" => 15}
    else
      bonuses = JSON.parse!(@playerobject.bonuses)
    end
    bonuses['event'] += 1 #the longer you go with no event, the higher your chances of something happening

    buttontype = params['option'].first[0]
    case buttontype
    when "broccoli"
      @mypoints += 10
      flash["star"] = "+10 bonus: #{@mypoints} points!"
      bonuses["broccoli"] = 0
    when "cherry"
      @mypoints *= 3
      flash["star"] = "Triple bonus: #{@mypoints} points!"
      bonuses["cherry"] = 0
    when "grain"
      @mypoints *= 2
      flash["star"] = "Double bonus: #{@mypoints} points!"
      bonuses["grain"] = 0
    when "lettuce"
      @mypoints += 5
      flash["star"] = "+5 bonus: #{@mypoints} points!"
      bonuses["lettuce"] = 0
    when "strawberry"
      @mypoints += 20
      flash["star"] = "+20 bonus: #{@mypoints} points!"
      bonuses["strawberry"] = 0
    else #passed as "default"
      flash["star"] = "#{@mypoints} points!"
    end

    diceroll = rand(50) - (bonuses['event']*2)
    diceroll = rand(12) if diceroll <= 0
    case diceroll
    when 1
      bonuses["cherry"] = rand(6)+6
      flash["cherry"] = "Use Cherry for a TRIPLE score!"
      bonuses['event'] = 0
    when 2,3
      bonuses["grain"] = rand(6)+6
      flash["grain"] = "Use Grain for a DOUBLE score!"
      bonuses['event'] = 0
    when 3,4
      bonuses["strawberry"] = rand(6)+6
      flash["strawberry"] = "Use Strawberry for +20 points!"
      bonuses['event'] = 0
    when 5,6,7,8
      bonuses["broccoli"] = rand(6)+6
      flash["broccoli"] = "Use Broccoli for +10 points!"
      bonuses['event'] = 0
    when 9,10,11,12
      bonuses["lettuce"] = rand(6)+6
      flash["lettuce"] = "Use Lettuce +5 points!"
      bonuses['event'] = 0
    end

    if params['iam'] == params['answer'] then
      @yourresults = "Winner!"
      @mystyle = "background-color: #9fde89;" #subdued green
      Topic.update_counters @mytopic, sucesses: 1

      playerhash = @playerobject.sucesses
      if playerhash.nil? or playerhash == "" then
        playerhash = {}
      else
        playerhash = JSON.parse!(@playerobject.sucesses)
      end

      if playerhash[@mysubject.to_s].nil? then
        playerhash[@mysubject.to_s] = 1
      else
        playerhash[@mysubject.to_s] = playerhash[@mysubject.to_s] + 1
      end
      @playerobject.sucesses = JSON.fast_generate(playerhash)

      #add points
      playerhash = @playerobject.scores
      if playerhash.nil? or playerhash == "" then
        playerhash = {}
      else
        playerhash = JSON.parse!(@playerobject.scores)
      end

      if playerhash[@mysubject.to_s].nil? then
        playerhash[@mysubject.to_s] = @mypoints
      else
        currentpoints = playerhash[@mysubject.to_s]
        #Check for leveling up
        if currentpoints < 100 and (currentpoints + @mypoints) >= 100 then
          flash["levelup"] = "You know #{@mysubject}! Level up to 10pt questions!"
        end
        if currentpoints < 500 and (currentpoints + @mypoints) >= 500 then
          flash["levelup"] = "The #{@mysubject} ultimate challenge begins! Level up to 20pt questions!"
        end
        if currentpoints < 1000 and (currentpoints + @mypoints) >= 1000 then
          flash["levelup"] = "You are a #{@mysubject} master!"
        end
        playerhash[@mysubject.to_s] = currentpoints + @mypoints
      end
      @playerobject.scores = JSON.fast_generate(playerhash)
    else
      @yourresults = "Incorrect."
      @mystyle = "background-color: #de8989;" #subdued red
      Topic.update_counters @mytopic, failures: 1

      playerhash = @playerobject.failures
      if playerhash.nil? or playerhash == "" then
        playerhash = {}
      else
        playerhash = JSON.parse!(@playerobject.failures)
      end
      if playerhash[@mysubject.to_s].nil? then
        playerhash[@mysubject.to_s] = 1
      else
        playerhash[@mysubject.to_s] = playerhash[@mysubject.to_s] + 1
      end
      @playerobject.failures = JSON.fast_generate(playerhash)

      flash.delete("star")
    end

    @playerobject.bonuses = JSON.fast_generate(bonuses)
    @playerobject.save

    scores = JSON.parse!(@playerobject.scores)
    @myscore = scores[@mysubject].to_i

    @quizquestion = Product.find_by(id: params['iam'])
    @quizanswer = Product.find_by(id: params['answer'])

    @playersubject = @playerobject.subject
  end


  def buildquestion_easy (myfield, mytesttype, checkmaxvalue)
    #the easiest, Answer from the end 30% of value, wrong Answres from the other 60%
    @quizquestions = []

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
    while @quizquestions == [] do
      @quizquestions = Product.random(myfield, testmin, testmax)
    end
    @winnerid = @quizquestions[0]['id']
    selectedids = @winnerid.to_s

    4.times do
      newquizquestion = Product.random(myfield, ansmin, ansmax, selectedids)
      if newquizquestion == [] then
        buildquestion_easy(myfield, mytesttype, checkmaxvalue)
        #View recursive error correction ... works. saw it hit 10x on 330 products.
        #puts "****************************************RESET"
        break
      else
        selectedids += " and id <> " + newquizquestion[0]['id'].to_s
        @quizquestions += newquizquestion
      end
    end
  end


  def buildquestion_med (myfield, mytesttype, checkmaxvalue)
    #medium difficulty - All random
    @quizquestions = []

    if mytesttype == false then
      testmin = 0.0001
      testmax = checkmaxvalue * 0.70000
    else
      testmin = checkmaxvalue * 0.30000
      testmax = checkmaxvalue + 1
    end

    #select uniq winner and four questions
    while @quizquestions == [] do
      @quizquestions = Product.random(myfield, testmin, testmax)
    end
    @winnerid = @quizquestions[0]['id']
    selectedids = @winnerid.to_s
    # note mytesttype == false for least
    if mytesttype == false then
      ansmin = @quizquestions[0][myfield] + 0.0001
      ansmax = checkmaxvalue + 1
    else
      ansmin = 0.0001
      ansmax = @quizquestions[0][myfield] - 0.0001
    end
    newquizquestion = []

    4.times do
      newquizquestion = Product.random(myfield, ansmin, ansmax, selectedids)
      if newquizquestion == [] then
        buildquestion_med(myfield, mytesttype, checkmaxvalue)
        break
      else
        selectedids += " and id <> " + newquizquestion[0]['id'].to_s
        @quizquestions += newquizquestion
      end
    end
  end


  def buildquestion_hard (myfield, mytesttype, checkmaxvalue)
    #Challenging, select from a tight range of values
    @quizquestions = []

    #select uniq winner and four questions
    while @quizquestions == [] do
      @quizquestions = Product.random(myfield, 0, checkmaxvalue)
    end
    @winnerid = @quizquestions[0]['id']
    selectedids = @winnerid.to_s

    if mytesttype == false then # note mytesttype == false for least
      ansmin = @quizquestions[0][myfield] + 0.0001
      ansmax = @quizquestions[0][myfield] + (checkmaxvalue * 0.30000)
    else
      ansmin = @quizquestions[0][myfield] - (checkmaxvalue * 0.30000)
      ansmax = @quizquestions[0][myfield] - 0.0001
    end

    4.times do
      newquizquestion = Product.random(myfield, ansmin, ansmax, selectedids)
      if newquizquestion == [] then
        buildquestion_hard(myfield, mytesttype, checkmaxvalue)
        break
      else
        selectedids += " and id <> " + newquizquestion[0]['id'].to_s
        @quizquestions += newquizquestion
      end
    end
  end


end
