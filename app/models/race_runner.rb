class RaceRunner < ActiveRecord::Base
  attr_accessible :nationality, :number, :team , :year, :race_id, :cyclist_id, :team_id
  belongs_to :race
  belongs_to :cyclist
  belongs_to :team
  has_many :ite_stage_results
end
