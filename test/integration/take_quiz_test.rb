require 'test_helper'

class TakeQuizTest < Capybara::Rails::TestCase
  def setup
  end

  test 'load quiz questions' do
    optionalbuttons = ["broccoli", "cherry", "grain", "lettuce", "strawberry"]

    puts "Testing quiz question page load"

    visit quests_path
    #Is there a challenge page loaded?
    assert page.has_content?('challenge')

    #Do we have five questions to choose?
    assert page.has_button?('button_0'), "No button for answer 0"
    assert page.has_button?('button_1'), "No button for answer 1"
    assert page.has_button?('button_2'), "No button for answer 2"
    assert page.has_button?('button_3'), "No button for answer 3"
    assert page.has_button?('button_4'), "No button for answer 4"

    #randomly select first answer and jump to results page
    mydice = "button_#{rand(5).to_s}"
    page.click_button(mydice)

    #pick a topic challenge to test on and select that instead of random
    #mychallenge = Topic.random[0].name
    mychallenges = Topic.subjectnames
    mychallenges.each do |r|
      mychallenge = r.name

      page.select mychallenge, :from => 'mysubject'
      #java script does not trigger onchange
      page.click_button('Pick your subject:')

      # take test, randomly answering questions and hitting next on the results page
      for iteration in 0..500 do
        mylastscore = page.find('#score').text.split(" ")[0].to_i

        #check for bonuses
        mychoice = Array.new

        optionalbuttons.each do |bonus|
          if page.has_button?("button_1_#{bonus}") then
            for pick in 0..4 do
              mychoice.push("button_#{pick.to_s}_#{bonus}")
            end
          end
        end

        for pick in 0..4 do
          mychoice.push("button_#{pick.to_s}")
        end

        #randomly select an answer
        mydice = mychoice[rand(mychoice.count)] #{}"button_#{rand(5).to_s}"
        puts "#{iteration}: #{mylastscore} pts for #{mychallenge}. Selecting #{mydice.split("_")[2]} #{mydice.split("_")[1]}"

        page.click_button(mydice)

        assert page.has_link?('button_next'), "No link to next question page load: #{iteration}"

        myscore = page.find('#score').text.split(" ")[0].to_i
        break if myscore > 1025

        #check for leveling up
        if myscore >= 100 && mylastscore < 100 then
          puts "#{iteration}: level up award detected"
          assert page.has_content?('Level up')
        end
        if myscore >= 500 && mylastscore < 500 then
          puts "#{iteration}: level up award detected"
          assert page.has_content?('Level up')
        end
        if myscore >= 1000 && mylastscore < 1000 then
          puts "#{iteration}: level up award detected"
          assert page.has_content?('master')
        end

        page.click_link('button_next')
      end
    end

  end

end
