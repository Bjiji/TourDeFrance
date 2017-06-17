class Team < ActiveRecord::Base
  #attr_accessor :name, :description
  has_many :race_teams
  has_many :races, :through => :race_teams
  has_many :race_runners, :through => :race_teams
  has_many :cyclists, -> { distinct }, :through => :race_runners

  def p_races
    p_races = races.select('distinct races.*')
  end
end
