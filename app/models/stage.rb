class Stage < ActiveRecord::Base
  attr_accessible :date, :distance, :finish, :finishers_cnt, :label, :runners_cnt, :stageNb, :stage_type, :start, :subStageNb, :year
  belongs_to :race
  has_many :ite_stage_results
  has_one :ig_stage_result

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
    tmp_name = year.to_s  + ':'
    stage_name = tmp_name + stage_num
  end

  def display_label
    display_label = stage_name + ' ' + start + ' / ' + finish
  end

  def winner
    winner = Cyclist.find_by_sql("select c.* from ig_stage_results isr join race_runners rr on rr.id = isr.stage_winner_id join cyclists c on c.id = rr.cyclist_id where isr.stage_id = " + self.id.to_s).first
  end

  def leader
    winner = Cyclist.find_by_sql("select c.* from ig_stage_results isr join race_runners rr on rr.id = isr.leader_id join cyclists c on c.id = rr.cyclist_id where isr.stage_id = " + self.id.to_s).first
  end

  def self.search(search)
    lastname = search[:lastname]  || ""
    lastname_condition = "%" + lastname + "%"
    firstname = search[:firstname]  || ""
    firstname_condition = "%" + firstname + "%"
    nationality = search[:nationality]  || ""
    nationality_condition = "%" + nationality + "%"
    start_city_condition = "%"
    end_city_condition = "%"
    city = "%" + (search[:city] || "") + "%"
    if (search[:city_kind] == "both") then
      start_city_condition = city
      end_city_condition =  city
    elsif (search[:city_kind] == "start")
      start_city_condition =  city
      end_city_condition =  "-"
    elsif (search[:city_kind] == "end")
      start_city_condition =  "-"
      end_city_condition =  city
    end
    year = search[:year]
    if (year == nil)
      year = ''
    end
    year_condition = "%" + year + "%"
    y_operator = "LIKE "
    if (search[:year_operator] == "equals") then
      y_operator = " LIKE "
      year_condition = "%" + year + "%"
    elsif (search[:year_operator] == "before") then
      y_operator = " < "
      year_condition = year
    elsif (search[:year_operator] == "since") then
      y_operator = " > "
      year_condition = year
    end
    s_type = search[:s_type]
    if (s_type == nil || s_type == '')
      s_type = '%'
    end
    type_condition = s_type
#        Stage.connection.select("select distinct s.* from stages s join ite_stage_results isr on isr.stage_id = s.id and isr.pos = 1 where s.year LIKE '"+ year_condition + "'")
    query = "SELECT distinct stages.*
      FROM stages
      LEFT JOIN ig_stage_results ON ig_stage_results.stage_id = stages.id
      LEFT JOIN race_runners runner ON runner.year = stages.year
      LEFT JOIN cyclists cyclist ON cyclist.id = runner.cyclist_id
      LEFT JOIN ite_stage_results isr ON isr.stage_id = stages.id AND runner.id = isr.race_runner_id
      WHERE stages.year " +  y_operator + " '" + year_condition + "'
      AND stages.stage_type LIKE '" + type_condition + "'
      AND (stages.start LIKE '" + start_city_condition + "' OR stages.finish LIKE '" + end_city_condition + "')
      AND cyclist.lastname LIKE '" + lastname_condition + "'
      AND cyclist.firstname LIKE '" + firstname_condition + "'
      AND cyclist.nationality LIKE '" + nationality_condition + "'"
    if search[:c_finish_leader] == "yes" then query = query + " AND ig_stage_results.leader_id=runner.id "
    elsif search[:c_finish_leader] == "no" then query = query + " AND ig_stage_results.leader_id!=runner.id "
    end
    if search[:c_start_leader] == "yes" then query = query + " AND ig_stage_results.previous_leader_id=runner.id "
    elsif search[:c_start_leader] == "no" then query = query + " AND ig_stage_results.previous_leader!=runner.id "
    end
    if search[:c_finish_climber] == "yes" then query = query + " AND ig_stage_results.climber_id=runner.id "
    elsif search[:c_finish_climber] == "no" then query = query + " AND ig_stage_results.climber_id!=runner.id "
    end
    if search[:c_start_climber] == "yes" then query = query + " AND ig_stage_results.previous_climber=runner.id "
    elsif search[:c_start_climber] == "no" then query = query + " AND ig_stage_results.previous_climber!=runner.id "
    end
    if search[:c_finish_sprinter] == "yes" then query = query + " AND ig_stage_results.sprinter_id=runner.id "
    elsif search[:c_finish_sprinter] == "no" then query = query + " AND ig_stage_results.sprinter_id!=runner.id "
    end
    if search[:c_start_sprinter] == "yes" then query = query + " AND ig_stage_results.previous_sprinter=runner.id "
    elsif search[:c_start_sprinter] == "no" then query = query + " AND ig_stage_results.previous_sprinter!=runner.id "
    end
    if search[:c_stage_pos] == "winner" then query = query + " AND ig_stage_results.stage_winner_id=runner.id "
    elsif search[:c_stage_pos] == "nowinner" then query = query + " AND ig_stage_results.stage_winner_id!=runner.id "
    elsif search[:c_stage_pos] == "podium" then query = query + " AND isr.pos <= 3 "
    elsif search[:c_stage_pos] == "topten" then query = query + " AND isr.pos <= 10 "
    elsif search[:c_stage_pos] == "finish" then query = query + " AND (!isr.dns && !isr.dnf && !isr.dnq) "
    elsif search[:c_stage_pos] == "nofinish" then query = query + " AND (isr.dns || isr.dnf || isr.dnq) "
    elsif search[:c_stage_pos] == "dns" then query = query + " AND (isr.dns) "
    elsif search[:c_stage_pos] == "dnq" then query = query + " AND (isr.dnq) "
    elsif search[:c_stage_pos] == "dnf" then query = query + " AND (isr.dnf) "

    end
#AND ig_stage_results.stage_winner=runner.id
#AND ig_stage_results.leader=runner.id
#AND ig_stage_results.climber=runner.id
#AND ig_stage_results.sprinter=runner.id
#      AND ite_stage_results.pos < 10

    Stage.find_by_sql(query)
  end


end
