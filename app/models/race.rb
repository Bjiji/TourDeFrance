class Race < ActiveRecord::Base
  attr_accessible :averageSpeed, :description, :distance, :name, :poolPrize, :winnerPrize, :year
  has_many :race_runners
  has_many :stages
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

  def leader
    result =  IgRaceResult.where(:race_id => self).first
    if (result == nil || result.leader == nil) then
      leader = nil
    else
      leader = result.leader.cyclist
    end
  end

end
