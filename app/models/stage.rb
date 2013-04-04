class Stage < ActiveRecord::Base
  attr_accessible :date, :distance, :finish, :finishers_cnt, :label, :runners_cnt, :stageNb, :stage_type, :start, :subStageNb, :year
  belongs_to :race
  has_many :ite_stage_results

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

  def winner
    result =  IteStageResult.where(:stage_id => self, :pos => 1).first
    if (result == nil) then
      winner = nil
    else
      winner = result.race_runner.cyclist
    end
  end

    def self.search(search)
      winner = search[:winner]
      if (winner == nil)
        winner = ''
      end
      winner_condition = "%" + winner + "%"

      year = search[:year]
      if (year == nil)
        year = ''
      end
      year_condition = "%" + year + "%"

      p_start = search[:start]
      if (p_start == nil)
        p_start = ''
      end
      start_condition = "%" + p_start + "%"

      finish = search[:finish]
      if (finish == nil)
        finish = ''
      end
      finish_condition = "%" + finish + "%"

      s_type = search[:s_type]
      if (s_type == nil || s_type == '')
        s_type = '%'
      end
      type_condition = s_type


      Stage.joins(:ite_stage_results => [{:race_runner => :cyclist}]).where(:ite_stage_results => { :pos => 1 }).all(:select => 'distinct stages.*', :conditions => ['stages.year LIKE ? AND stages.stage_type LIKE ? AND stages.start LIKE ? and stages.finish LIKE ? AND (cyclists.lastname LIKE ? OR cyclists.firstname LIKE ?)', year_condition, type_condition, start_condition, finish_condition, winner_condition, winner_condition])
#        Stage.connection.select("select distinct s.* from stages s join ite_stage_results isr on isr.stage_id = s.id and isr.pos = 1 where s.year LIKE '"+ year_condition + "'")

    end


end
