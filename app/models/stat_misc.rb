class StatMisc < ActiveRecord::Base

  def self.statDnf(year)
    sql_array = [%q{select s.runners_cnt - s.finishers_cnt as 'nb',  format(100 * (s.runners_cnt - s.finishers_cnt) / s.runners_cnt, 1) as 'percent', s.*
from stages s
where s.year > ?
group by s.id
order by 1 desc limit 25;}, year]
    sql = ActiveRecord::Base::sanitize_sql_array(sql_array)
    statDnf = Stage.find_by_sql(sql)
  end

  def self.statSuccStages(year)
    sql_array = [%q{SELECT distinct stages.id as stage1, stages2.id as stage2, stages3.id as stage3, rteam.id as team, runner.id as runner1, runner2.id as runner2, runner3.id as runner3
 FROM stages
 LEFT JOIN ig_stage_results igsr ON igsr.stage_id = stages.id
 LEFT JOIN race_runners runner ON runner.year = stages.year and runner.id = igsr.stage_winner_id
 LEFT JOIN race_teams rteam ON rteam.id = runner.race_team_id
  LEFT JOIN teams team on team.id = rteam.team_id
 LEFT JOIN ite_stage_results isr ON isr.stage_id = stages.id AND runner.id = isr.race_runner_id

 LEFT JOIN stages stages2 on stages2.year = stages.year and stages2.ordinal = stages.ordinal + 1
 LEFT JOIN ig_stage_results igsr2 ON igsr2.stage_id = stages2.id
 LEFT JOIN race_runners runner2 ON runner2.year = stages2.year and runner2.id = igsr2.stage_winner_id
 LEFT JOIN ite_stage_results isr2 ON isr2.stage_id = stages2.id AND runner2.id = isr2.race_runner_id

 LEFT JOIN stages stages3 on stages3.year = stages.year and stages3.ordinal = stages.ordinal + 2
 LEFT JOIN ig_stage_results igsr3 ON igsr3.stage_id = stages3.id
 LEFT JOIN race_runners runner3 ON runner3.year = stages3.year and runner3.id = igsr3.stage_winner_id
 LEFT JOIN ite_stage_results isr3 ON isr3.stage_id = stages3.id AND runner3.id = isr3.race_runner_id

 WHERE stages.year > ?
 and runner.race_team_id = runner2.race_team_id
 and runner.race_team_id = runner3.race_team_id
 order by stages.year desc, stages.ordinal desc limit 25
 ;}, year]
    sql = ActiveRecord::Base::sanitize_sql_array(sql_array)
    statSuccStages = ActiveRecord::Base.connection.select_all(sql)
  end

  def self.stage_age(column_name, order, limit, nationality, year)

    if (limit.blank?) then
      limit = "5"
    end
    if (order == 'asc') then
      group_method = 'min'
    else
      group_method = 'max'
    end

    query = "select #{group_method}(datediff(s.date, c.dob)) as day_age, ig.id as ig_id, c.id as c_id, s.id as s_id, r.id as r_id
    from cyclists c
    join race_runners rr on rr.cyclist_id = c.id
    join ig_stage_results ig on ig.#{column_name} = rr.id
    join stages s on s.id = ig.stage_id
    join races r on r.id = rr.race_id
    where c.dob > 0 "
    if (!year.blank?) then
      query += " and r.year > #{year} "
    end
    if (!nationality.blank?) then
      query += " and rr.nationality like '#{nationality}' "
    end
    query += " group by rr.id
    order by 1 #{order}
    limit #{limit};"

    sql = ActiveRecord::Base::sanitize_sql_array(query)
    stage_age = ActiveRecord::Base.connection.select_all(sql)

  end

  def self.race_age(column_name, order, limit, nationality, year)

    if (limit.blank?) then
      limit = "5"
    end
    if (order == 'asc') then
      group_method = 'min'
    else
      group_method = 'max'
    end

    query = "select #{group_method}(datediff(s.date, c.dob)) as day_age, ig.id as ig_id, c.id as c_id, s.id as s_id, r.id as r_id
    from cyclists c
    join race_runners rr on rr.cyclist_id = c.id
    join ig_race_results ig on ig.#{column_name} = rr.id
    join races r on r.id = rr.race_id
    join stages s on s.race_id = r.id and s.is_last
    where c.dob > 0 "
    if (!year.blank?) then
      query += " and r.year > #{year} "
    end
    if (!nationality.blank?) then
      query += " and rr.nationality like '#{nationality}' "
    end
    query += " group by rr.id
    order by 1 #{order}
    limit #{limit};"

    sql = ActiveRecord::Base::sanitize_sql_array(query)
    stage_age = ActiveRecord::Base.connection.select_all(sql)

  end

end
