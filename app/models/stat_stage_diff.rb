class StatStageDiff

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
      query = "SELECT min(isr2.diff_time_sec) as diff_time, stages.*
      FROM stages
      LEFT JOIN ig_stage_results ON ig_stage_results.stage_id = stages.id
      LEFT JOIN ite_stage_results isr2 ON isr2.stage_id = stages.id AND isr2.pos > 1 AND  isr2.pos < 15 AND isr2.diff_time_sec > 10
      LEFT JOIN ite_stage_results isr ON isr.stage_id = stages.id
      LEFT JOIN race_runners runner ON runner.year = stages.year AND runner.id = isr.race_runner_id
      LEFT JOIN cyclists cyclist ON cyclist.id = runner.cyclist_id
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
      query = query + " group by stages.id order by isr2.diff_time_sec desc limit 30"
#AND ig_stage_results.stage_winner=runner.id
#AND ig_stage_results.leader=runner.id
#AND ig_stage_results.climber=runner.id
#AND ig_stage_results.sprinter=runner.id
#      AND ite_stage_results.pos < 10

      Stage.find_by_sql(query)
    end
end
