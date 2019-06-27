class RaceRunner < ActiveRecord::Base
  #attr_accessor :nationality, :number, :team , :year, :race_id, :cyclist_id, :team_id
  belongs_to :race
  belongs_to :cyclist
  belongs_to :race_team
  delegate :team, :to => :race_team, :allow_nil => true
  has_many :ite_stage_results

def display_name
  if (cyclist == nil)
  then
    display_name = "? (#{name})"
  else display_name = cyclist.display_name
  end
end

  def display_fullname
    if (cyclist == nil)
    then
      display_fullname = "? (#{name})"
    else display_fullname = "#{cyclist.display_fullname}"
    end
  end

  def other_races
    cyclist.other_races_on_year(year)
  end

  def has_other_races
    !(cyclist.other_races_on_year(year).blank?)
  end

  def display_other_races
    res = other_races.map { |otr| "#{otr.race_label} (#{otr.year})" }.join("\n")
    res
  end

end
