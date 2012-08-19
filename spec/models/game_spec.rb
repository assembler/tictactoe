require 'spec_helper'

describe Game do
  subject { build(:game) }

  describe 'validation' do
    it { should     be_valid }
    it { should_not have_valid(:player).when(nil, '', 'k') }
    it { should     have_valid(:player).when('x', 'o') }
  end

  describe '.stats' do
    it 'returns stats hash with win, lose and draw keys' do
      create_list(:game, 1, victory: true)
      create_list(:game, 2, victory: false)
      create_list(:game, 3, victory: nil)
      stats = Game.stats
      stats[:win].should == 1
      stats[:lose].should == 2
      stats[:draw].should == 3
    end
  end

end
