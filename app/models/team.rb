class Team < ActiveRecord::Base
  #attr_accessor :name, :description
  has_many :race_teams
  has_many :races, :through => :race_teams
  has_many :race_runners, :through => :race_teams
  has_many :cyclists, -> { distinct }, :through => :race_runners

  def p_races
    p_races = races.select('distinct races.*')
  end

  def stage_victories
    IgStageResult.find_by_sql("select ig.* from ig_stage_results ig
join stages s on s.id = ig.stage_id
left join race_runners rr on rr.id = ig.stage_winner_id
left join race_teams rt on rt.id = rr.race_team_id
left join race_teams rt2 on rt2.id = ig.race_team_id
where rt2.team_id = #{self.id} or rt.team_id = #{self.id} order by s.year desc, s.ordinal desc")

  end
end
