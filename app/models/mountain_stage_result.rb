class MountainStageResult < ActiveRecord::Base
  #attr_accessor :name, :category_s, :finish, :order, :leader_id, :altitude, :year, :stage_id
  belongs_to :stage
  belongs_to :race_runner, :class_name => "RaceRunner", :foreign_key => "leader_id"

  def display_leader
    if (race_runner == nil || race_runner.cyclist ==  nil)
      then display_leader = leader_s
    else
      display_leader = race_runner.display_name
    end
  end

  def self.search(search)
    mountain_name = if(search[:m_name].blank?) then "%" else "%" + search[:m_name] + "%" end
    mountain_category = search[:m_category] || "%"
    mountain_finish = search[:m_finish]
    department = "%#{search[:department]}%"
    country = "%#{search[:country]}%"
    lastname_condition = "%#{search[:lastname]}%"
    firstname_condition = "%#{search[:firstname]}%"
    nationality = search[:nationality]  || ""
    nationality_condition = "%" + nationality + "%"
    start_city_condition = "%"
    end_city_condition = "%"
    city = "%" + (search[:city] || "") + "%"
    if (search[:city_kind] == "both") then
      join_location = "LEFT JOIN stage_locations sl on sl.id = stages.start_location OR sl.id = stages.finish_location "
      start_city_condition = city
      end_city_condition =  city
    elsif (search[:city_kind] == "start")
      join_location = "LEFT JOIN stage_locations sl on sl.id = stages.start_location "
      start_city_condition =  city
      end_city_condition =  "-"
    elsif (search[:city_kind] == "end")
      join_location = "LEFT JOIN stage_locations sl on sl.id = stages.finish_location "
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

    altitude = search[:altitude] || ''
    altitude_condition = "%" + altitude + "%"
    a_operator = "LIKE "
    if (search[:altitude_operator] == "equals") then
      a_operator = " LIKE "
      altitude_condition = "%" + altitude + "%"
    elsif (search[:altitude_operator] == "less") then
      a_operator = " < "
      altitude_condition = altitude
    elsif (search[:altitude_operator] == "more") then
      a_operator = " > "
      altitude_condition = altitude
    end


    s_type = search[:s_type]
    if (s_type == nil || s_type == '')
      s_type = '%'
    end
    type_condition = s_type
#        Stage.connection.select("select distinct s.* from stages s join ite_stage_results isr on isr.stage_id = s.id and isr.pos = 1 where s.year LIKE '"+ year_condition + "'")
    query = "SELECT distinct msr.*
      FROM mountain_stage_results msr
      LEFT JOIN race_runners runner ON msr.leader_id = runner.id
      LEFT JOIN cyclists cyclist ON cyclist.id = runner.cyclist_id
      LEFT JOIN stages ON msr.stage_id = stages.id
      #{join_location}
      LEFT JOIN ig_stage_results ON ig_stage_results.stage_id = stages.id
      LEFT JOIN ite_stage_results isr ON isr.stage_id = stages.id AND runner.id = isr.race_runner_id "
    if (!search[:other_race].blank?) then
      query = query + " \njoin other_races otr on otr.cyclist_id = cyclist.id and otr.race_name = '#{search[:other_race]}'"
      if (!search[:other_race_same_year].blank?) then
        query += "AND otr.year = runner.year "
      end
    end
    query += " WHERE stages.year " +  y_operator + " '" + year_condition + "' "
    if (!mountain_name.blank?) then query = query + "AND msr.name LIKE \"" + mountain_name + "\" " end
    if (!mountain_category.blank?) then query = query + "AND msr.category_s LIKE '" + mountain_category + "' " end
    if (!mountain_finish.blank?)   then query = query + "AND msr.finish = '" + mountain_finish + "' " end
    if (!altitude.blank?) then query = query + "AND msr.altitude " +  a_operator + " '" + altitude_condition + "'" end
      query += "AND stages.stage_type LIKE '" + type_condition + "'
      AND stages.stage_type LIKE '" + type_condition + "'
      AND (sl.id is NULL OR sl.department LIKE '#{department}' OR sl.code LIKE '#{department}')
      AND (sl.id is NULL or sl.country LIKE \"#{country}\")
      AND (stages.start LIKE '" + start_city_condition + "' OR stages.finish LIKE '" + end_city_condition + "') "
       if (!search[:lastname].blank?) then query = query + " AND cyclist.lastname LIKE '" + lastname_condition + "'"  end
    if (!search[:firstname].blank?) then query = query + " AND cyclist.firstname LIKE '" + firstname_condition + "'" end
    if (!search[:nationality].blank?) then query = query + " AND cyclist.nationality LIKE '" + nationality_condition + "'" end
    if search[:c_finish_leader] == "yes" then
      query = query + " AND ig_stage_results.leader_id=runner.id "
    elsif search[:c_finish_leader] == "no" then
      query = query + " AND ig_stage_results.leader_id!=runner.id "
    end
    if (search[:first_time]) then
      query = query + " AND not exists(select 1 from race_runners r2 where r2.cyclist_id = runner.cyclist_id and r2.year < runner.year)"
    end
    if search[:c_start_leader] == "yes" then query = query + " AND ig_stage_results.previous_leader=runner.id "
    elsif search[:c_start_leader] == "no" then query = query + " AND ig_stage_results.previous_leader!=runner.id "
    end
    if search[:c_finish_climber] == "yes" then
      query = query + " AND ig_stage_results.climber_id=runner.id "
    elsif search[:c_finish_climber] == "no" then
      query = query + " AND ig_stage_results.climber_id!=runner.id "
    end
    if search[:c_start_climber] == "yes" then query = query + " AND ig_stage_results.previous_climber=runner.id "
    elsif search[:c_start_climber] == "no" then query = query + " AND ig_stage_results.previous_climber!=runner.id "
    end
    if search[:c_finish_sprinter] == "yes" then
      query = query + " AND ig_stage_results.sprinter_id=runner.id "
    elsif search[:c_finish_sprinter] == "no" then
      query = query + " AND ig_stage_results.sprinter_id!=runner.id "
    end
    if search[:c_start_sprinter] == "yes" then query = query + " AND ig_stage_results.previous_sprinter=runner.id "
    elsif search[:c_start_sprinter] == "no" then query = query + " AND ig_stage_results.previous_sprinter!=runner.id "
    end
    if search[:c_finish_young] == "yes" then query = query + " AND ig_stage_results.young_id=runner.id "
    elsif search[:c_finish_young] == "no" then query = query + " AND (ig_stage_results.young_id is null OR ig_stage_results.young_id!=runner.id) "
    end
    if search[:c_start_young] == "yes" then query = query + " AND ig_stage_results.previous_young=runner.id "
    elsif search[:c_start_young] == "no" then query = query + " AND  (ig_stage_results.previous_young is null OR ig_stage_results.previous_young!=runner.id) "
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

    MountainStageResult.find_by_sql(query)
  end
end
