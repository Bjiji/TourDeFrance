class Race < ActiveRecord::Base
  attr_accessible :averageSpeed, :description, :distance, :name, :poolPrize, :winnerPrize, :year, :cyclist, :leader_id
  belongs_to :cyclist
  has_many :race_runners
  has_many :stages
  has_many :cyclists ,:through => :race_runners
  has_one :ig_race_result

  def winner
    result =  IgRaceResult.where(:race_id => self).first
    if (result == nil || result.leader == nil) then
      winner = nil
    else
      winner = result.leader.cyclist
    end
  end

  def sprinter
    result =  IgRaceResult.where(:race_id => self).first
    if (result == nil || result.sprinter == nil) then
      winner = nil
    else
      winner = result.sprinter.cyclist
    end
  end

  def climber
    result =  IgRaceResult.where(:race_id => self).first
    if (result == nil || result.climber == nil) then
      winner = nil
    else
      winner = result.climber.cyclist
    end
  end

end
