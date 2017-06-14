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


  def stats
    $myheader = nil

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

    #generate a hash of player succes counts
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
