class Stage < ActiveRecord::Base
  attr_accessible :date, :distance, :finish, :finishers_cnt, :label, :runners_cnt, :stageNb, :stage_type, :start, :subStageNb, :year
  belongs_to :race

def stage_num
  res = ''
  if (stageNb < 10) then
    res = res + '0' + stageNb.to_s
  else
    res = res + stageNb.to_s
  end
  if (subStageNb != 0) then
  res = res  + ':' + subStageNb.to_s
  end
  stage_num = res
end

  def stage_name
    tmp_name = year.to_s  + ' etape '
    stage_name = tmp_name + stage_num
  end

  def display_label
    display_label = stage_name + ': ' + start + ' => ' + finish
  end

end
