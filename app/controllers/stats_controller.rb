class StatsController < ApplicationController
  respond_to :json

  def show
    respond_with Game.stats
  end

end
