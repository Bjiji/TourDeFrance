class Stage < ActiveRecord::Base
  #attr_accessor :race_id, :date, :info, :distance, :ordinal, :finish, :finishers_cnt, :label, :runners_cnt, :stageNb, :stage_type, :start, :subStageNb, :year
  belongs_to :race
  has_many :ite_stage_results
  has_one :ig_stage_result

  def stage_num
    res = ''
    if (stageNb != nil && subStageNb != nil) then
      if (stageNb < 10) then
        res = res + '0' + stageNb.to_s
      else
        res = res + stageNb.to_s
      end
      if (subStageNb != 0) then
        res = res + ':' + subStageNb.to_s
      end
    end
    stage_num = res
  end

  def stage_name
    tmp_name = year.to_s + ':'
    stage_name = tmp_name + stage_num
  end

  def display_simple_label
    display_label = (start.blank? ? '?' : start) + ' › ' + (finish.blank? ? '?' : finish)
  end

  def display_label
    "#{stage_name} #{display_simple_label} (#{stage_type})"
  end


  def team_winner
    if (ig_stage_result != nil) then
      ig_stage_result.race_team
    else
      nil
    end
  end

  def winner
    if (ig_stage_result != nil) then
      ig_stage_result.stage_winner
    else
      nil
    end
  end

  def leader
    if (ig_stage_result != nil) then
      ig_stage_result.leader
    else
      nil
    end
  end

  def sprinter
    if (ig_stage_result != nil) then
      ig_stage_result.sprinter
    else
      nil
    end
  end

  def climber
    if (ig_stage_result != nil) then
      ig_stage_result.climber
    else
      nil
    end
  end

  def young
    if (ig_stage_result != nil) then
      ig_stage_result.young
    else
      nil
    end
  end

  def self.missingResults()
    query = "SELECT distinct stages.*
      FROM stages
      LEFT JOIN ig_stage_results ig ON ig.stage_id = stages.id
      WHERE ig.stage_winner_id is null"
    Stage.find_by_sql(query)
  end

  def self.search(search)
    team = search[:team] || ""
    department = "%#{search[:department]}%"
    country = "%#{search[:country]}%"
    lastname_condition = "%#{search[:lastname]}%"
    firstname_condition = "%#{search[:firstname]}%"
    nationality = search[:nationality] || ""
    nationality_condition = nationality
    start_city_condition = "%"
    end_city_condition = "%"
    city = "%" + (search[:city] || "") + "%"
    if (search[:city_kind] == "both") then
      join_location = "LEFT JOIN stage_locations sl on sl.id = stages.start_location OR sl.id = stages.finish_location "
      start_city_condition = city
      end_city_condition = city
    elsif (search[:city_kind] == "start")
      join_location = "LEFT JOIN stage_locations sl on sl.id = stages.start_location "
      start_city_condition = city
      end_city_condition = "-"
    elsif (search[:city_kind] == "end")
      join_location = "LEFT JOIN stage_locations sl on sl.id = stages.finish_location "
      start_city_condition = "-"
      end_city_condition = city
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
      #{join_location}
    LEFT JOIN ig_stage_results ON ig_stage_results.stage_id = stages.id
    LEFT JOIN ite_stage_results isr ON isr.stage_id = stages.id
    LEFT JOIN race_runners runner ON isr.race_runner_id = runner.id and runner.year = stages.year
    LEFT JOIN race_teams rteam on rteam.id = runner.race_team_id
    LEFT JOIN teams team on team.id = rteam.team_id
    LEFT JOIN cyclists cyclist ON cyclist.id = runner.cyclist_id
    "
    if (!search[:other_race].blank?) then
      query = query + " \njoin other_races otr on otr.cyclist_id = cyclist.id and otr.race_name = '#{search[:other_race]}'"
      if (!search[:other_race_same_year].blank?) then
        query += "AND otr.year = runner.year "
      end
    end
    query +=

      "WHERE stages.year " + y_operator + " '" + year_condition + "'
      AND (sl.id is NULL OR sl.department LIKE '#{department}' OR sl.code LIKE '#{department}')
      AND (sl.id is NULL or sl.country LIKE '#{country}')
      AND stages.stage_type LIKE '" + type_condition + "%'
      AND (stages.start LIKE '" + start_city_condition + "' OR stages.finish LIKE '" + end_city_condition + "') "
    if (!search[:lastname].blank?) then
      query = query + " AND cyclist.lastname LIKE '" + lastname_condition + "'"
    end
    if (!search[:firstname].blank?) then
      query = query + " AND cyclist.firstname LIKE '" + firstname_condition + "' "
    end
    if (!search[:nationality].blank?) then
      query = query + " AND runner.nationality = '" + nationality_condition + "'"
    end
    if search[:c_finish_leader] == "yes" then
      query = query + " AND ig_stage_results.leader_id=runner.id "
    elsif search[:c_finish_leader] == "no" then
      query = query + " AND (ig_stage_results.leader_id is null OR ig_stage_results.leader_id!=runner.id) "
    end
    if search[:c_start_leader] == "yes" then
      query = query + " AND ig_stage_results.previous_leader=runner.id "
    elsif search[:c_start_leader] == "no" then
      query = query + " AND (ig_stage_results.previous_leader is null OR ig_stage_results.previous_leader!=runner.id) "
    end
    if search[:c_finish_climber] == "yes" then
      query = query + " AND ig_stage_results.climber_id=runner.id "
    elsif search[:c_finish_climber] == "no" then
      query = query + " AND (ig_stage_results.climber_id is null OR ig_stage_results.climber_id!=runner.id) "
    end
    if search[:c_start_climber] == "yes" then
      query = query + " AND ig_stage_results.previous_climber=runner.id "
    elsif search[:c_start_climber] == "no" then
      query = query + " AND  (ig_stage_results.previous_climber is null OR ig_stage_results.previous_climber!=runner.id) "
    end
    if search[:c_finish_young] == "yes" then query = query + " AND ig_stage_results.young_id=runner.id "
    elsif search[:c_finish_young] == "no" then query = query + " AND (ig_stage_results.young_id is null OR ig_stage_results.young_id!=runner.id) "
    end
    if search[:c_start_young] == "yes" then query = query + " AND ig_stage_results.previous_young=runner.id "
    elsif search[:c_start_young] == "no" then query = query + " AND  (ig_stage_results.previous_young is null OR ig_stage_results.previous_young!=runner.id) "
    end


    if search[:c_finish_sprinter] == "yes" then
      query = query + " AND ig_stage_results.sprinter_id=runner.id "
    elsif search[:c_finish_sprinter] == "no" then
      query = query + " AND (ig_stage_results.sprinter_id is null OR ig_stage_results.sprinter_id!=runner.id) "
    end
    if search[:c_start_sprinter] == "yes" then
      query = query + " AND ig_stage_results.previous_sprinter=runner.id "
    elsif search[:c_start_sprinter] == "no" then
      query = query + " AND (ig_stage_results.previous_sprinter is null OR ig_stage_results.previous_sprinter!=runner.id) "
    end
    if search[:c_stage_pos] == "winner" then
      query = query + " AND ig_stage_results.stage_winner_id=runner.id "
    elsif search[:c_stage_pos] == "nowinneram.b" then
      query = query + " AND (ig_stage_results.stage_winner_id is null OR ig_stage_results.stage_winner_id!=runner.id) "
    elsif search[:c_stage_pos] == "topthree" then
      query = query + " AND isr.pos <= 3 "
    elsif search[:c_stage_pos] == "topten" then
      query = query + " AND isr.pos <= 10 "
    elsif search[:c_stage_pos] == "finish" then query = query + " AND NOT (isr.pos is null) "
    elsif search[:c_stage_pos] == "nofinish" then query = query + " AND ((isr.pos is null)) "
    elsif search[:c_stage_pos] == "dns" then query = query + " AND (isr.dns)"
    elsif search[:c_stage_pos] == "dnq" then query = query + " AND (isr.dnq) "
    elsif search[:c_stage_pos] == "dnf" then query = query + " AND (isr.dnf) "
    end
    if (!(team == nil) && !team.blank?) then
      query = query + " AND team.name LIKE '%" + team + "%'"
    end
    if (search[:first_time]) then
      query = query + " AND not exists(select 1 from race_runners r2 where r2.cyclist_id = runner.cyclist_id and r2.year < runner.year)"
    end
#AND ig_stage_results.stage_winner=runner.id
#AND ig_stage_results.leader=runner.id
#AND ig_stage_results.climber=runner.id
#AND ig_stage_results.sprinter=runner.id
#      AND ite_stage_results.pos < 10

    Stage.find_by_sql(query)
  end

end
