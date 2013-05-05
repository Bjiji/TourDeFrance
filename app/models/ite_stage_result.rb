 class IteStageResult < ActiveRecord::Base
  attr_accessible :diff_time_sec, :dnf, :dnq, :dns, :pos, :time_sec, :stage_status, :stage_tag, :race_runner_id
  belongs_to :stage
  belongs_to :race_runner


  def display_time
    if (time_sec == nil || time_sec == 0) then
      str_time_sec  = " - "
    else
      str_time_sec = ChronicDuration.output(time_sec)
    end
    if (diff_time_sec == nil) then
      str_diff_time_sec  = " - "
    else
      str_diff_time_sec = (diff_time_sec / 60).to_s + "'" + (diff_time_sec % 60).to_s + "''"
    end
    # display_time = str_time_sec + ' (' + str_diff_time_sec + ')'
    display_time = str_diff_time_sec
  end

  def display_tag
    res = ''
    if (dns == 1)  then
      res = 'non partant'
    end
    if (dnf == 1) then
      res = res + 'non classe'
    end
    if (dnq == 1)  then
      res = res + 'disqualifie'
    end
    display_tag = res

  end


  def self.search(search)
    team = search[:team]  || ""
    lastname = search[:lastname]  || ""
    lastname_condition = "%" + lastname + "%"
    firstname = search[:firstname]  || ""
    firstname_condition = "%" + firstname + "%"
    nationality = search[:nationality]  || ""
    nationality_condition = nationality
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
    query = "SELECT isr.*
      FROM stages
      LEFT JOIN ig_stage_results ON ig_stage_results.stage_id = stages.id
      LEFT JOIN ite_stage_results isr ON isr.stage_id = stages.id
      LEFT JOIN race_runners runner ON isr.race_runner_id = runner.id and runner.year = stages.year
      LEFT JOIN teams team on team.id = runner.team_id
      LEFT JOIN cyclists cyclist ON cyclist.id = runner.cyclist_id
      WHERE stages.year " +  y_operator + " '" + year_condition + "'
      AND stages.stage_type LIKE '" + type_condition + "'
      AND (stages.start LIKE '" + start_city_condition + "' OR stages.finish LIKE '" + end_city_condition + "')
      AND cyclist.lastname LIKE '" + lastname_condition + "'
      AND cyclist.firstname LIKE '" + firstname_condition + "' "
    if (!search[:nationality].blank?) then query = query + " AND runner.nationality = '" + nationality_condition + "'" end
    if search[:c_finish_leader] == "yes" then query = query + " AND ig_stage_results.leader_id=runner.id "
    elsif search[:c_finish_leader] == "no" then query = query + " AND (ig_stage_results.leader_id is null OR ig_stage_results.leader_id!=runner.id) "
    end
    if search[:c_start_leader] == "yes" then query = query + " AND ig_stage_results.previous_leader=runner.id "
    elsif search[:c_start_leader] == "no" then query = query + " AND (ig_stage_results.previous_leader is null OR ig_stage_results.previous_leader!=runner.id) "
    end
    if search[:c_finish_climber] == "yes" then query = query + " AND ig_stage_results.climber_id=runner.id "
    elsif search[:c_finish_climber] == "no" then query = query + " AND (ig_stage_results.climber_id is null OR ig_stage_results.climber_id!=runner.id) "
    end
    if search[:c_start_climber] == "yes" then query = query + " AND ig_stage_results.previous_climber=runner.id "
    elsif search[:c_start_climber] == "no" then query = query + " AND  (ig_stage_results.previous_climber is null OR ig_stage_results.previous_climber!=runner.id) "
    end
    if search[:c_finish_sprinter] == "yes" then query = query + " AND ig_stage_results.sprinter_id=runner.id "
    elsif search[:c_finish_sprinter] == "no" then query = query + " AND (ig_stage_results.sprinter_id is null OR ig_stage_results.sprinter_id!=runner.id) "
    end
    if search[:c_start_sprinter] == "yes" then query = query + " AND ig_stage_results.previous_sprinter=runner.id "
    elsif search[:c_start_sprinter] == "no" then query = query + " AND (ig_stage_results.previous_sprinter is null OR ig_stage_results.previous_sprinter!=runner.id) "
    end
    if search[:c_stage_pos] == "winner" then query = query + " AND ig_stage_results.stage_winner_id=runner.id "
    elsif search[:c_stage_pos] == "nowinneram.b" then query = query + " AND (ig_stage_results.stage_winner_id is null OR ig_stage_results.stage_winner_id!=runner.id) "
    elsif search[:c_stage_pos] == "topthree" then query = query + " AND isr.pos <= 3 "
    elsif search[:c_stage_pos] == "topten" then query = query + " AND isr.pos <= 10 "
    elsif search[:c_stage_pos] == "finish" then query = query + " AND (isr.pos > 0) "
    elsif search[:c_stage_pos] == "nofinish" then query = query + " AND (isr.pos is null) OR not(isr.pos > 0) "
    elsif (!(search[:c_stage_pos].blank?) && search[:c_stage_pos].start_with?("dnf")) then query = query + " AND (isr.stage_status = '" + search[:c_stage_pos][3..-1] + "') "
    elsif search[:c_stage_pos] == "dnq" then query = query + " AND (isr.dnq) "
    elsif search[:c_stage_pos] == "dnf" then query = query + " AND (isr.dnf) "
    end
    if(!(team == nil) && !team.blank?) then query = query + " AND team.name LIKE '%" + team + "%'" end
    if(search[:first_time]) then query = query + " AND not exists(select 1 from race_runners r2 where r2.cyclist_id = runner.cyclist_id and r2.year < runner.year)" end
    query = query + " order by stages.year desc, stages.ordinal desc, isr.pos asc limit 500"
#AND ig_stage_results.stage_winner=runner.id
#AND ig_stage_results.leader=runner.id
#AND ig_stage_results.climber=runner.id
#AND ig_stage_results.sprinter=runner.id
#      AND ite_stage_results.pos < 10

    IteStageResult.find_by_sql(query)
  end

end
