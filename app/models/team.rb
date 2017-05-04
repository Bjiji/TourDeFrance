class Team < ActiveRecord::Base
  #attr_accessor :name, :description
  has_many :cyclists, :through => :race_runners
  has_many :races, :through => :race_runners
  has_many :race_runners

  def p_races
    p_races = races.select('distinct races.*')
  end
end
