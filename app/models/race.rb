class Race < ActiveRecord::Base
  #attr_accessor :averageSpeed, :description, :distance, :name, :poolPrize, :winnerPrize, :year
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

  def young
    result =  IgRaceResult.where(:race_id => self).first
    if (result == nil || result.young == nil) then
      young = nil
    else
      young = result.young.cyclist
    end
  end

  def nationalities
    sql = 'SELECT distinct nationality
 FROM race_runners rr
 WHERE rr.race_id =' + id.to_s + ';'
    nationalities = Stage.connection.select_all(sql)
  end

end
