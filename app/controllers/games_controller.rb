class GamesController < ApplicationController
  respond_to :json

  def create
    @game = Game.new game_params
    @game.save
    respond_with @game
  end

  private
  def game_params
    params.require(:game).permit(:player, :victory)
  end

end
