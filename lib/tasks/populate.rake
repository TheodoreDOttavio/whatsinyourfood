namespace :db do
  desc "Add products to db"
  task :populate => :environment do
 #This hits up a website to pull in about 800 products
#its not all food... so... not all applicable.
#Booleans in the model will flag it as 'is searched ' and 'is_associated'

require "net/http"

ActiveRecord::Base.transaction do
puts Quest.destroy_all
puts "cleaned out"

for i in 2..44 #44 pages.

datastring = "http://www.grocerypricebooks.com/upc-list"
datastring += "/?pn=#{i}" if i != 1

puts "loading page " + datastring

uri = URI(datastring)
thisimport = Net::HTTP.get(uri)

# trim before '<h1>UPC Database</h1>'
# trim after '<tr><td id="paginationDisplay">&nbsp;  '

mystart = thisimport.index('<h1>UPC Database</h1>') + '<h1>UPC Database</h1>'.length
myend = thisimport.index("<tr><td id=\"paginationDisplay\">&nbsp;  ")
myend -= 1

#remove html
myimport =  thisimport[mystart..myend].gsub(%r{</?[^>]+?>}, '')
#remove the tabs
myimport = myimport.gsub(/\t+/, '')
#drop each line into an array
myimportarray =  myimport.split("\n")

#clean out whitespaces and empty entries
myimportarray.map{|entry| entry.strip }
myimportarray = myimportarray.keep_if{|entry| entry != ""}

(0..12).each do
  myimportarray.shift
end

while myimportarray.empty? == false do
Quest.create!(manufacturer: myimportarray.shift,
                 name: myimportarray.shift + " " + myimportarray.shift,
                 size: myimportarray.shift.strip,
                 upc: myimportarray.shift,
                 is_searched: false,
                 is_associated: false)
#  puts myimportarray.shift + myimportarray.shift + myimportarray.shift + myimportarray.shift.gsub(/\s+/, '') + myimportarray.shift + " next "
#  puts myimportarray.shift + myimportarray.shift + myimportarray.shift + myimportarray.shift.strip + myimportarray.shift + " next "
end

puts "completed page " + i.to_s
end

end

end

# Rake db:calcpercent

  desc "Calculate the percentages for product data"
  task :calcpercent => :environment do
    #this application helper that calculates it is now in the index controller.
    #  this rake task is to update legacy datum
    include ApplicationHelper
    
    myset = Product.select(:id)
    puts "loaded in " + myset.count.to_s + " products"
    myset.each do |s|
      #puts "updating " + s.item_name.to_s
      gramstopercent(s.id)
    end
    end
  

  desc "Calculate the percentages for product data"
  task :resetplayers => :environment do
    #Resets users
    Players.destroy_all
   end
    
    
end