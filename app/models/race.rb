class Race < ActiveRecord::Base
  #attr_accessor :averageSpeed, :description, :distance, :name, :poolPrize, :winnerPrize, :year
  has_many :race_runners
  has_many :stages
  has_one :ig_race_result
  has_one :race_team, :through => :ig_race_result

  def display_name
    "Édition #{year}"
  end
  def winner
    if (ig_race_result == nil || ig_race_result.leader == nil) then
      nil
    else
      ig_race_result.leader.cyclist
    end
  end

  def overall_combat
    if (ig_race_result == nil || ig_race_result.combat == nil) then
      nil
    else
      ig_race_result.combat.cyclist
    end
  end


  def sprinter
    if (ig_race_result == nil || ig_race_result.sprinter == nil) then
      nil
    else
      ig_race_result.sprinter.cyclist
    end
  end

  def climber
    if (ig_race_result == nil || ig_race_result.climber == nil) then
      nil
    else
      ig_race_result.climber.cyclist
    end
  end

  def leader
    winner
  end

  def young
    if (ig_race_result == nil || ig_race_result.young == nil) then
      nil
    else
      ig_race_result.young.cyclist
    end
  end

  def nationalities
    sql = 'SELECT distinct nationality
 FROM race_runners rr
 WHERE rr.race_id =' + id.to_s + ';'
    nationalities = Stage.connection.select_all(sql)
  end

end
