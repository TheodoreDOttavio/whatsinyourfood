require 'test_helper'

class TakeQuizTest < Capybara::Rails::TestCase
  def setup
  end

  test 'load quiz questions' do
    Capybara.javascript_driver = :webkit

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
    mychallenge = Topic.random[0].name

    page.select mychallenge, :from => 'mysubject'
    #java script does not trigger onchange
    page.click_button('Pick your subject:')

    # take test, randomly answering questions and hitting next on the results page
    for iteration in 0..23 do
      myscore = page.find('#score').text#.split(" ")[0].to_i
      #puts "#{myscore} at load #{iteration}"

puts page.find('#header h2').text

      #randomly select an answer
      mydice = "button_#{rand(5).to_s}"

      #TODO check for bunses and follow button_subject
      page.click_button(mydice)

      assert page.has_link?('button_next'), "No link to next question page load: #{iteration}"

      page.click_link('button_next')
    end

  end

end
