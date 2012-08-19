require 'spec_helper'

describe StatsController do

  describe 'show' do
    before do
      Game.stub(:stats).and_return({ foo: 'bar' })
    end

    it 'returns stats' do
      get :show, format: :json
      JSON.parse(response.body)['foo'].should == 'bar'
    end
  end

end
