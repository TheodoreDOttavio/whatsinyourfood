class StaticPagesController < ApplicationController
  def home
    @needlogin = true
    @loginmessage = params['loginmsg']

    $userid = cookies[:user_id]

    if $userid.nil? == false then
      obj = Player.find_by(id: $userid.to_i)
      if obj.password != "" then
        @needlogin = false
        @playername = obj.name
      end
    end

  end


  def login
    #first- check to see if they just left both fields blank
    if params['myname'] == "display name" and params['mypassword'] == "password" then
      #Do nothing, just redirect
    else
      logmsg = ""
      #This may have data and is different than the login
      #  Record current id,
      #  do a lookup - ask again or create/assign
      #  merge in current id,
      #  reset cookies
      currentid = $userid

      storedpass = Digest::SHA1.hexdigest(params['mypassword'])

      #Do a lookup
      if params['myname'] != "display name"
        obj = Player.find_by(name: params['myname'])
      else
        params['myname'] = ""
        obj = Player.find_by(password: storedpass)
      end

      if obj.nil? then #Create because nothing was found on name or password
        obj = Player.new
        $userid = obj.id
        obj.update(:name => params['myname'])
        obj.update(:password => storedpass)
        obj.save
        cookies[:user_id] = $userid
        logmsg = "Your account has been created."
      else
        #doublecheck password
        if obj['password'] == storedpass then #login!
          $userid = obj.id
          obj.update(:name => params['myname'])
          obj.save
          cookies[:user_id] = $userid
          logmsg = "Welcome back #{params['myname']}"
        else
          logmsg = "The name #{params['myname']} does not match the password."
        end
      end

      #check for a merge
      if currentid != $userid then
        oldobj = Player.find_by(id: currentid)
        if oldobj.nil? == false then
          #generate a hash of player succes scores
          playersucesses = obj.sucesses
          if playersucesses.nil? or playersucesses == "" then
            playersucesses = {}
          else
            playersucesses = JSON.parse!(obj.sucesses)
          end
          playerfailures = obj.failures
          if playerfailures.nil? or playerfailures == "" then
            playerfailures = {}
          else
            playerfailures = JSON.parse!(obj.failures)
          end

          #generate a hash of old player succes scores
          oldplayersucesses = oldobj.sucesses
          if oldplayersucesses.nil? or oldplayersucesses == "" then
            oldplayersucesses = {}
          else
            oldplayersucesses = JSON.parse!(oldobj.sucesses)
          end
          oldplayerfailures = oldobj.failures
          if oldplayerfailures.nil? or oldplayerfailures == "" then
            oldplayerfailures = {}
          else
            oldplayerfailures = JSON.parse!(oldobj.failures)
          end

          oldplayersucesses.each do |id,val|
            if playersucesses[id].nil? then
              playersucesses[id] = val
            else
              playersucesses[id] += val
            end
          end

          oldplayerfailures.each do |id,val|
            if playerfailures[id].nil? then
              playerfailures[id] = val
            else
              playerfailures[id] += val
            end
          end

          obj.sucesses = JSON.fast_generate(playersucesses)
          obj.failures = JSON.fast_generate(playerfailures)
          obj.save

          oldobj.delete

          #just to be clear... re-assert the cookies
          $userid = obj.id
          cookies[:user_id] = $userid
        end #if oldobj.nil?
      end #end merge

    end #check for doing nothing
    redirect_to root_path(loginmsg: logmsg)
  end


  def about
    #depreciating this to just send the user to the home page...
    #  it was a fun exercise, but no need to be silly...

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
    @playercount = Player.count

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

    #generate a hash of player succes scores
    playersucesses = obj.sucesses
    if playersucesses.nil? or playersucesses == "" then
      playersucesses = {}
    else
      playersucesses = JSON.parse!(obj.sucesses)
    end
    playerfailures = obj.failures
    if playerfailures.nil? or playerfailures == "" then
      playerfailures = {}
    else
      playerfailures = JSON.parse!(obj.failures)
    end

    psucesses = 0
    pfailures = 0

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

      playerpercentcorrect = 0
      if playersucesses[t.id.to_s].nil? == false then
        if playerfailures[t.id.to_s].nil? then
          playerpercentcorrect = 1
        else
          playerpercentcorrect = playersucesses[t.id.to_s]/(playersucesses[t.id.to_s] + playerfailures[t.id.to_s] + 0.00) if playersucesses[t.id.to_s] != 0
        end
      end
      playerpercentcorrect = playerpercentcorrect *100

      @results.push({"name" => t.statement,
        "percentcorrect" => percentcorrect.round,
        "playerpercentcorrect" => playerpercentcorrect.round
        })
        psucesses += playersucesses[t.id.to_s].to_i
        pfailures += playerfailures[t.id.to_s].to_i
    end

    playerpercent = 0
    playerpercent = psucesses/(psucesses + pfailures + 0.00) if psucesses != 0
    playerpercent = playerpercent *100
    @playerpercent = playerpercent.round

    @playertotal = psucesses + pfailures

  end #stats


end
