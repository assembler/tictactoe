require 'spec_helper'

describe GamesController do

  describe 'create' do
    it 'creats new game' do
      expect {
        post :create, game: { player: 'x' }, format: :json
      }.to change { Game.count }.by 1
      response.should be_success
    end
  end

end
