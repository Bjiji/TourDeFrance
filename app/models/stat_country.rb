class StatCountry < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.partNat(nationality)

    sql_array = [ %q{select ? as nat, r.year as year, count(distinct(rr.id)) as part,
cast(count(1) / greatest(count(distinct(rr.id)), 1) as signed int) as tot
 from races r
 left join race_runners rr on rr.race_id = r.id and rr.nationality like ?
 join race_runners rr2 on rr2.race_id = r.id
 group by year
 order by year;}, nationality, nationality ]
    sql = ActiveRecord::Base::sanitize_sql_array(sql_array)
    partNat = ActiveRecord::Base.connection.select_all(sql)
  end

  def self.statNatRace(nationality)
    sql_array = [ %q{select ? as nationality,
count(distinct part.id) as dossard,
count(distinct part.cyclist_id) as cyclist,
count(distinct leader.cyclist_id) as leader,
count(distinct sprinter.cyclist_id) as sprinter,
count(distinct climber.cyclist_id) as climber
from
races r
join ig_race_results irr
left join race_runners part on part.race_id = r.id and part.nationality = ?
left join race_runners leader on leader.id = irr.leader_id and leader.nationality = ?
left join race_runners climber on climber.id = irr.climber_id  and climber.nationality = ?
left join race_runners sprinter on sprinter.id = irr.sprinter_id  and sprinter.nationality = ?
;}, nationality, nationality, nationality, nationality, nationality ]
    sql = ActiveRecord::Base::sanitize_sql_array(sql_array)
    statNatRace = ActiveRecord::Base.connection.select_one(sql)
  end

  def self.statNatStage(nationality)
    sql_array = [ %q{select ? as nationality, count(distinct winner.id) as winner, count(distinct leader.id) as leader, count(distinct sprinter.id) as sprinter, count(distinct climber.id) as climber from
stages s
join ig_stage_results isr on isr.stage_id = s.id
left join race_runners winner on winner.id = isr.stage_winner_id and winner.nationality = ?
left join race_runners leader on leader.id = isr.leader_id and leader.nationality = ?
left join race_runners sprinter on sprinter.id = isr.sprinter_id and sprinter.nationality = ?
left join race_runners climber on climber.id = isr.climber_id and climber.nationality = ?}, nationality, nationality, nationality, nationality, nationality ]
    sql = ActiveRecord::Base::sanitize_sql_array(sql_array)
    statNatStage = ActiveRecord::Base.connection.select_one(sql)
  end
end
