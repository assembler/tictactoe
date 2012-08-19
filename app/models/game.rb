class Game < ActiveRecord::Base
  attr_accessible :player, :victory

  validates :player, presence: true, inclusion: { in: %w[ x o ] }

  def self.stats
    {
      win:  where(victory: true).count,
      lose: where(victory: false).count,
      draw: where(victory: nil).count
    }
  end

end
