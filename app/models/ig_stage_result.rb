class IgStageResult < ActiveRecord::Base
  #attr_accessor :stage_winner_s, :stage_winner_id, :leader_id, :sprinter_id, :climber_id
  belongs_to :stage
  belongs_to :leader, :class_name => "RaceRunner", :foreign_key => "leader_id"
  belongs_to :sprinter, :class_name => "RaceRunner", :foreign_key => "sprinter_id"
  belongs_to :climber, :class_name => "RaceRunner", :foreign_key => "climber_id"
  belongs_to :young, :class_name => "RaceRunner", :foreign_key => "young_id"
  belongs_to :stage_winner, :class_name => "RaceRunner", :foreign_key => "stage_winner_id"
  belongs_to :race_team, :class_name => "RaceTeam", :foreign_key => "race_team_id"
  delegate :team, :to => :race_team, :allow_nil => true
  belongs_to :previous_leader, :class_name => "RaceRunner", :foreign_key => "previous_leader"
  belongs_to :previous_sprinter, :class_name => "RaceRunner", :foreign_key => "previous_sprinter"
  belongs_to :previous_climber, :class_name => "RaceRunner", :foreign_key => "previous_climber"
  belongs_to :previous_young, :class_name => "RaceRunner", :foreign_key => "previous_young"
  belongs_to :previous_stage_winner, :class_name => "RaceRunner", :foreign_key => "previous_stage_winner"
end
