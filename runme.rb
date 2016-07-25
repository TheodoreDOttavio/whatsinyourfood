tester = "Spaghetti O\'s Plus Calcium"
#puts tester.gsub(((?:[-a-z0-9]+\.)*[-a-z0-9]+.*)/i, "")
puts URI.escape(tester)

testresults = {"6" => 10, "9" =>1}

puts testresults

if testresults[5.to_s].nil? then
  testresults[5.to_s] = 1
end
testresults[5.to_s] = testresults["5"] + 1

puts testresults

puts "... to Json and back"

check = JSON.generate(testresults)
puts check

final = JSON.parse(check)
puts final
