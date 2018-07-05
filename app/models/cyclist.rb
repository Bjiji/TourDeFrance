class Cyclist < ActiveRecord::Base
 # attr_accessor :description, :dob, :firstname, :lastname, :nationality, :pob, :tag, :races
  has_many :race_runners
  has_many :race_teams, :through => :race_runners
  has_many :races, :through => :race_runners
  has_many :ite_stage_results, :through => :race_runners

  def lastname_c
    lastname_c = if (lastname.blank?) then
                   '?'
                 else
                   (lastname)
                 end
  end

  def firstname_c
    firstname_c = if (firstname.blank?) then
                    '?'
                  else
                    (firstname)
                  end
  end

  def display_name
    "#{firstname_c.byteslice(0)}. #{lastname_c.upcase}"
  end

  def display_fullname
    "#{firstname_c} #{lastname_c.upcase}"
  end

  def race_starts
    if (races == nil) then
     0
    else
      races.count
    end
  end

  def race_victories
    race_victories = Cyclist.count_by_sql("select count(1) from ig_race_results join race_runners rr on rr.id = leader_id where cyclist_id = " + self.id.to_s)
  end

  def stage_victories
    stage_victories = Cyclist.count_by_sql("select count(1) from ig_stage_results join race_runners rr on rr.id = stage_winner_id where rr.cyclist_id = " + self.id.to_s)
  end

  def self.normalize
    @cyclists = Cyclist.all
    @cyclists.each do |cyclist|
      cyclist.lastname = cyclist.lastname.split(' ').each { |word| word.capitalize! }.join(' ')
      cyclist.save
    end
  end

  def self.search(search)
    lastname = search[:lastname]
    if (lastname == nil)
      lastname = ''
    end
    lastname_condition = "%" + lastname + "%"

    firstname = search[:firstname]
    if (firstname == nil)
      firstname = ''
    end
    firstname_condition = "%" + firstname + "%"

    nationality = search[:nationality]
    if (nationality == nil)
      nationality = ''
    end
    nat_condition = nationality

    team = search[:team]
    if (team == nil)
      team = ''
    end
    team_condition = "%" + team + "%"

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
      y_operator = " <= "
      year_condition = year
    elsif (search[:year_operator] == "since") then
      y_operator = " >= "
      year_condition = year
    end


    #Cyclist.joins(:teams).all(:select => 'distinct cyclists.*', :conditions => ['teams.name LIKE ? AND cyclists.nationality LIKE ? AND cyclists.lastname LIKE ? AND cyclists.firstname LIKE ?', team_condition, nat_condition, lastname_condition, firstname_condition])


    query = "select distinct c.*
    from cyclists c
    inner join race_runners r on r.cyclist_id = c.id
   left JOIN race_teams ON race_teams.id = r.race_team_id
    left JOIN teams ON teams.id = race_teams.team_id "
    if (!search[:wjaune_cnt].blank? && search[:wjaune_cnt].to_i > 0)
      query = query + " \nleft join ig_race_results ir_jaune on ir_jaune.leader_id = r.id "
    end
    if (!search[:wsprinter_cnt].blank? && search[:wsprinter_cnt].to_i > 0)
      query = query + " \nleft join ig_race_results ir_sprinter on ir_sprinter.sprinter_id = r.id "
    end
    if (!search[:wclimber_cnt].blank? && search[:wclimber_cnt].to_i > 0)
      query = query + " \nleft join ig_race_results ir_climber on ir_climber.climber_id = r.id "
    end
    if (!search[:wyoung_cnt].blank? && search[:wyoung_cnt].to_i > 0)
      query = query + " \nleft join ig_race_results ir_young on ir_young.young_id = r.id "
    end
    if (!search[:pjaune_cnt].blank? && search[:pjaune_cnt].to_i > 0)
      query = query + " \nleft join ig_stage_results is_jaune on is_jaune.leader_id = r.id "
    end
    if (!search[:psprinter_cnt].blank? && search[:psprinter_cnt].to_i > 0)
      query = query + " left join ig_stage_results is_sprinter on is_sprinter.sprinter_id = r.id "
    end
    if (!search[:pclimber_cnt].blank? && search[:pclimber_cnt].to_i > 0)
      query = query + " \nleft join ig_stage_results is_climber on is_climber.climber_id = r.id "
    end
    if (!search[:pyoung_cnt].blank? && search[:pyoung_cnt].to_i > 0)
      query = query + " \nleft join ig_stage_results is_young on is_young.young_id = r.id "
    end
    if (!search[:wstage_cnt].blank? && search[:wstage_cnt].to_i > 0)
      query = query + " \nleft join ig_stage_results is_stage on is_stage.stage_winner_id = r.id "
    end
    query = query + " WHERE (
    teams.name LIKE '" + team_condition + "' AND "
    if (!search[:nationality].blank?) then
      query = query + " c.nationality = '" + nationality + "' AND "
    end
    query = query + " c.lastname LIKE '" + lastname_condition + "' AND
    c.firstname LIKE '" + firstname_condition + "') AND
    r.year " + y_operator + " '" + year_condition + "' "
    if (search[:first_time]) then
      query = query + " AND not exists(select 1 from race_runners r2 where r2.cyclist_id = r.cyclist_id and r2.year < r.year)  "
    end
    query = query + " group by c.id"
    need_having_clause = true
    if (!search[:wjaune_cnt].blank? && search[:wjaune_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct ir_jaune.id) >= " + search[:wjaune_cnt]
      need_having_clause = false
    end
    if (!search[:wsprinter_cnt].blank? && search[:wsprinter_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct ir_sprinter.id) >= " + search[:wsprinter_cnt]
      need_having_clause = false
    end
    if (!search[:wclimber_cnt].blank? && search[:wclimber_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct ir_climber.id) >= " + search[:wclimber_cnt]
      need_having_clause = false
    end
    if (!search[:wyoung_cnt].blank? && search[:wyoung_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct ir_young.id) >= " + search[:wyoung_cnt]
      need_having_clause = false
    end

    if (!search[:pjaune_cnt].blank? && search[:pjaune_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct is_jaune.id) >= " + search[:pjaune_cnt]
      need_having_clause = false
    end
    if (!search[:psprinter_cnt].blank? && search[:psprinter_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct is_sprinter.id) >= " + search[:psprinter_cnt]
      need_having_clause = false
    end
    if (!search[:pclimber_cnt].blank? && search[:pclimber_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct is_climber.id) >= " + search[:pclimber_cnt]
      need_having_clause = false
    end
    if (!search[:pyoung_cnt].blank? && search[:pyoung_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct is_young.id) >= " + search[:pyoung_cnt]
      need_having_clause = false
    end
    if (!search[:wstage_cnt].blank? && search[:wstage_cnt].to_i > 0)
      if (need_having_clause) then
        query = query + " HAVING "
      else
        query = query + " AND "
      end
      query = query + " \n count(distinct is_stage.id) >= " + search[:wstage_cnt]
      need_having_clause = false
    end
    Cyclist.find_by_sql(query)
  end


end
