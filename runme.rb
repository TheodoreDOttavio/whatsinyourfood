testresults = {"6" => 10, "9" =>1}

puts testresults

if testresults[5.to_s].nil? then
  testresults[5.to_s] = 1
end
testresults[5.to_s] = testresults["5"] + 1

puts testresults