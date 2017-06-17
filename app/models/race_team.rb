class RaceTeam < ApplicationRecord
  belongs_to :race
  belongs_to :team
  has_many :race_runners
  has_many :cyclists, :through => :race_runners
end
