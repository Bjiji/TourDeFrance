class IgRaceResult < ActiveRecord::Base
  #attr_accessor :year, :leader_id, :sprinter_id, :climber_id
  belongs_to :race
  belongs_to :leader, :class_name => "RaceRunner", :foreign_key => "leader_id"
  belongs_to :sprinter, :class_name => "RaceRunner", :foreign_key => "sprinter_id"
  belongs_to :climber, :class_name => "RaceRunner", :foreign_key => "climber_id"
  belongs_to :young, :class_name => "RaceRunner", :foreign_key => "young_id"
  belongs_to :combine, :class_name => "RaceRunner", :foreign_key => "combine_id"
  belongs_to :combat, :class_name => "RaceRunner", :foreign_key => "overall_combat_id"
  belongs_to :team, :class_name => "Team", :foreign_key => "team_id"


  def self.find_by_leader(cyclist_id)
    find_by_sql("select irs.* from ig_race_results irs
    join race_runners r on r.id = irs.leader_id
    join cyclists c on c.id = r.cyclist_id
    where c.id = '" + cyclist_id + "'")
  end

  def self.find_by_sprinter(cyclist_id)
    find_by_sql("select irs.* from ig_race_results irs
    join race_runners r on r.id = irs.sprinter_id
    join cyclists c on c.id = r.cyclist_id
    where c.id = '" + cyclist_id + "'")
  end

  def self.find_by_young(cyclist_id)
    find_by_sql("select irs.* from ig_race_results irs
    join race_runners r on r.id = irs.young_id
    join cyclists c on c.id = r.cyclist_id
    where c.id = '" + cyclist_id + "'")
  end

  def self.find_by_climber(cyclist_id)
    find_by_sql("select irs.* from ig_race_results irs
    join race_runners r on r.id = irs.climber_id
    join cyclists c on c.id = r.cyclist_id
    where c.id = '" + cyclist_id + "'")
  end
end
