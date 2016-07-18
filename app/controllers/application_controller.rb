class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Mobylette::RespondToMobileRequests
end


#Environment notes
#using mashape.com
#User TedD Pass is just letter and jk

#Random UPC's - https://www.upcdatabase.com
#  http://upcdatabase.org/random

#list of food from
#United States Department of Agriculture
#  Agricultural Research Service
#  USDA Food Composition Databases
#-adjusted count - has just over 9000 items - pretty shitty list. details are for gov things, non branded, milk, milk 2%, milk with A & D....
#https://ndb.nal.usda.gov/ndb/foods?format=&count=&max=1000&order=desc
#https://ndb.nal.usda.gov/ndb/foods?qlookup=&fgcd=&manu=Hormel+Foods+Corp.&SYNCHRONIZER_TOKEN=f1f2d577-1bc2-48ab-b1c1-1bea01412fe6&SYNCHRONIZER_URI=%2Fndb%2Ffoods

=begin
Good list with UPC's not all on nutritionix API...
http://www.grocerypricebooks.com/upc-list/?sortResults=n

Nutrionx
@test = Unirest.get "https://nutritionix-api.p.mashape.com/v1_1/search/swiss%20cheese?fields=item_name%2Citem_id%2Cbrand_name%2Cnf_calories%2Cnf_total_fat",
        headers:{
          "X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
          "Accept" => "application/json"
        }

Random cute cat picture:
response = Unirest.get "https://nijikokun-random-cats.p.mashape.com/random",
  headers:{
    "X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
    "Accept" => "application/json"
  }

dummy data
response = Unirest.get "https://montanaflynn-dummy-data.p.mashape.com/person?count=5",
  headers:{
    "X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
    "Accept" => "application/json"
  }

OR Quirky screen names (for projects...but...BEGIN# These code snippets use an open-source library. http://unirest.io/ruby
response = Unirest.get "https://acedev-project-name-generator-v1.p.mashape.com/with-number",
  headers:{
    "X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
    "Accept" => "application/json"
  })


sentiment analysis - to generate revies off of quirky names?

  # These code snippets use an open-source library. http://unirest.io/ruby
response = Unirest.post "https://community-sentiment.p.mashape.com/text/",
  headers:{
    "X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
    "Content-Type" => "application/x-www-form-urlencoded",
    "Accept" => "application/json"
  },
  parameters:{
    "txt" => "cool actor"
  }

or more detailed, a bit more varience,
# These code snippets use an open-source library. http://unirest.io/ruby
response = Unirest.post "https://twinword-sentiment-analysis.p.mashape.com/analyze/",
  headers:{
    "X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
    "Content-Type" => "application/x-www-form-urlencoded",
    "Accept" => "application/json"
  },
  parameters:{
    "text" => "cool actor"
  }
  ...use the score for varience.

  ...and for comments, a Text spinner!
  response = Unirest.post "https://pozzad-text-spinner.p.mashape.com/textspinner/spin",
  headers:{
    "X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
    "Content-Type" => "application/x-www-form-urlencoded",
    "Accept" => "application/json"
  },
  parameters:{
    "text" => "{{omg|wtf|seriously?|}} This {{question|one|test|}} {{is ridiculous|is stupid|is sad|is lame|is impossible|makes no sense|needs to go}}!",
    "variationsNum" => 1
  }

 #negative
{{omg |wtf |WTF |seriously? |}}This {{question|one|test|}} {{is ridiculous|is stupid|is sad|is lame|is impossible|makes no sense|needs to go}}!

#positive
{{Lol|lol|LOL|HA|Ja|}}{{ So true!| That was easy!| I got this!| Rockin' it!|}}{{ :)| :-)| :p||}}

#neutral
{{meh |ummm... |whatever |nope. |who writes these? |}}{{This one was too easy|not so tough|:/|}}


gem "browser"

browser = Browser.new(:ua => "some string", :accept_language => "en-us")
if browser.mobile? then
  ismobile = "yup, a mobile Browser"
else
  ismobile = "Not a mobile browser"
end

=end
