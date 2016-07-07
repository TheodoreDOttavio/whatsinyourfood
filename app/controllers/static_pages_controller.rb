class StaticPagesController < ApplicationController
  def home
  end

  
  def about
    # Find a quirky username
    userreview = Unirest.get("https://acedev-project-name-generator-v1.p.mashape.com/with-number",
        headers:{"X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
          "Accept" => "application/json"})

    @user = userreview.body['spaced']

    #Feed the username into a sentiment analysis
    rating = Unirest.get "https://twinword-sentiment-analysis.p.mashape.com/analyze/",
      headers:{"X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
        "Content-Type" => "application/x-www-form-urlencoded",
        "Accept" => "application/json"},
      parameters:{
        "text" => @user}

     #use the sentiment analysys rating to generate 1-5 star rating
     score = (rating.body['score'] * 100).to_i
     score += 100
     @stars = 0
     @stars = score/40.0 if score != 0
     @stars = @stars.round + (rand(2)-1) #randomize the star rating to BS some personality
     @stars = 1 if @stars <= 0

     #Generate a comment by feed a text spinner a synonym string that matches the star rating
     case @stars
     when 1
       spinnerstring = "{{omg |wtf |WTF |seriously? |}}This {{site|one|test|}} {{is ridiculous|is stupid|is sad|is lame|is impossible|makes no sense|needs to go}}!"
     when 2,3
       spinnerstring = "{{meh |ummm... |whatever |nope. |who writes these? |}}{{This is too easy|easy...|not so tough|:/|}}"
     when 4,5
       spinnerstring = "{{Lol |lol |LOL |HA |Ja |}}{{This is addictive!|That was easy!|I got this!|good one|Rockin' it!|}}{{ :)| :-)| :p||}}"
     end

     response = Unirest.post "https://pozzad-text-spinner.p.mashape.com/textspinner/spin",
       headers:{"X-Mashape-Key" => "Kh6nGtA4nXmshOKQSehm72xY5olDp1nTnUljsnvR1blvOPdH5l",
         "Content-Type" => "application/x-www-form-urlencoded",
         "Accept" => "application/json"},
       parameters:{"variationsNum" => 1,
         "text" => spinnerstring}

     @comment = response.body["variations"][0]
  end

  def stats
    @productcount = Product.count
    
    #check/set user from cookie
    if $userid.nil? then
      $userid = cookies[:user_id]
      if $userid.nil? then
        obj = Player.new
        obj.save
        $userid = obj.id
        cookies[:user_id] = $userid
      end
    end
    obj = Player.find($userid.to_i)
    
    if obj.name == "no name" then
      @name = "Your results"
    else
      @name = obj.name
    end
    
    mytopics = Topic.forstats
    @results = Array.new
    mytopics.each do |t|
      percentcorrect = 0
      if t.sucesses.nil? == false then
        if t.failures.nil? then
          percentcorrect = 1
        else
          percentcorrect = t.sucesses/(t.sucesses + t.failures + 0.00) if t.sucesses != 0
        end
      end
      percentcorrect = percentcorrect *100
      
      @results.push({"name" => t.statement,
        "percentcorrect" => percentcorrect.round
        })
    end
    
  end #stats
  
end
