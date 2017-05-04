class IgStageResult < ActiveRecord::Base
  #attr_accessor :stage_winner_s, :stage_winner_id, :leader_id, :sprinter_id, :climber_id
  belongs_to :stage
  belongs_to :leader, :class_name => "RaceRunner", :foreign_key => "leader_id"
  belongs_to :sprinter, :class_name => "RaceRunner", :foreign_key => "sprinter_id"
  belongs_to :climber, :class_name => "RaceRunner", :foreign_key => "climber_id"
  belongs_to :stage_winner, :class_name => "RaceRunner", :foreign_key => "stage_winner_id"
  belongs_to :team_winner, :class_name => "Team", :foreign_key => "team_winner_id"
  belongs_to :previous_leader, :class_name => "RaceRunner", :foreign_key => "previous_leader"
  belongs_to :previous_sprinter, :class_name => "RaceRunner", :foreign_key => "previous_sprinter"
  belongs_to :previous_climber, :class_name => "RaceRunner", :foreign_key => "previous_climber"
  belongs_to :previous_stage_winner, :class_name => "RaceRunner", :foreign_key => "previous_stage_winner"
end
