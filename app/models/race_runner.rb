class RaceRunner < ActiveRecord::Base
  attr_accessible :nationality, :number, :team
  belongs_to :race
  belongs_to :cyclist
  belongs_to :team
  has_many :ite_stage_results
end
