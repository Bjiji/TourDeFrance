class RaceRunner < ActiveRecord::Base
  #attr_accessor :nationality, :number, :team , :year, :race_id, :cyclist_id, :team_id
  belongs_to :race
  belongs_to :cyclist
  belongs_to :team
  has_many :ite_stage_results

def display_name
  if (cyclist == nil)
  then display_name = '?'
  else display_name = cyclist.display_name
  end
end

  def display_fullname
    if (cyclist == nil)
    then display_fullname = '?'
    else display_fullname = cyclist.display_fullname
    end
  end

end
