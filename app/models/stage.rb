class Stage < ActiveRecord::Base
  attr_accessible :date, :distance, :finish, :finishers_cnt, :label, :runners_cnt, :stageNb, :stage_type, :start, :subStageNb, :year
  belongs_to :race

  def stage_name
    tmp_name = year.to_s  + ' etape '
    if (stageNb < 10) then
      tmp_name = tmp_name + "0" + stageNb.to_s
    else
      tmp_name = tmp_name + stageNb.to_s
    end
    if (subStageNb != 0) then
      tmp_name = tmp_name + ':' + subStageNb.to_s
    end
    stage_name = tmp_name
  end

  def display_label
    display_label = stage_name + ': ' + start + ' => ' + finish
  end

end
