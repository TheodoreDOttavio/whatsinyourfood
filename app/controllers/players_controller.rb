class PlayersController < ApplicationController

  def index
    @players = Player.all
  end

  def destroy
    Player.find(params[:format]).destroy
    redirect_to player_path
  end
end
