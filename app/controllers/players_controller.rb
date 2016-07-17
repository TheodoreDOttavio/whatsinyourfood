class PlayersController < ApplicationController
  def show
    @player = Player.find_by(id: $userid)
  end

  def index
    @players = Player.all
  end

  def destroy
    Player.find(params[:format]).destroy
    redirect_to player_path
  end
end
