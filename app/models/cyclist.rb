class Cyclist < ActiveRecord::Base
  attr_accessible :description, :dob, :firstname, :lastname, :nationality, :pob, :tag, :races
  has_many :race_runners
  has_many :teams, :through => :race_runners
  has_many :races ,:through => :race_runners
  has_many :ite_stage_results, :through => :race_runners
  has_many :ig_race_results, :through => :race_runners

  def display_name
    display_name = lastname.upcase + " " + firstname
  end

  def race_started
    race_started = races.count
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
    nat_condition = "%" + nationality + "%"

    team = search[:team]
    if (team == nil)
      team = ''
    end
    team_condition = "%" + team + "%"


    #Cyclist.joins(:teams).all(:select => 'distinct cyclists.*', :conditions => ['teams.name LIKE ? AND cyclists.nationality LIKE ? AND cyclists.lastname LIKE ? AND cyclists.firstname LIKE ?', team_condition, nat_condition, lastname_condition, firstname_condition])


    query = "select c.*
    from cyclists c
    inner join race_runners r on r.cyclist_id = c.id
    left JOIN teams ON teams.id = r.team_id "
    if (!search[:wjaune_cnt].blank? && search[:wjaune_cnt].to_i > 0)
      query = query + " \nleft join ig_race_results ir_jaune on ir_jaune.leader = r.id "
    end
    if (!search[:wsprinter_cnt].blank? && search[:wsprinter_cnt].to_i > 0)
      query = query + " \nleft join ig_race_results ir_sprinter on ir_sprinter.sprinter = r.id "
    end
    if (!search[:wclimber_cnt].blank? && search[:wclimber_cnt].to_i > 0)
      query = query + " \nleft join ig_race_results ir_climber on ir_climber.climber = r.id "
    end
    if (!search[:pjaune_cnt].blank? && search[:pjaune_cnt].to_i > 0)
      query = query + " \nleft join ig_stage_results is_jaune on is_jaune.leader = r.id "
    end
    if (!search[:psprinter_cnt].blank? && search[:psprinter_cnt].to_i > 0)
      query = query + " left join ig_stage_results is_sprinter on is_sprinter.sprinter = r.id "
    end
    if (!search[:pclimber_cnt].blank? && search[:pclimber_cnt].to_i > 0)
      query = query + " \nleft join ig_stage_results is_climber on is_climber.climber = r.id "
    end
    if (!search[:wstage_cnt].blank? && search[:wstage_cnt].to_i > 0)
      query = query + " \nleft join ig_stage_results is_stage on is_stage.stage_winner = r.id "
    end
    query = query + " WHERE (
    teams.name LIKE '" + team_condition + "' AND
    c.nationality LIKE '" + nat_condition + "' AND
    c.lastname LIKE '" + lastname_condition + "' AND
    c.firstname LIKE '" + firstname_condition + "')
    group by c.id"
    need_having_clause = true
    if (!search[:wjaune_cnt].blank? && search[:wjaune_cnt].to_i > 0)
      if (need_having_clause) then query = query + " HAVING " else query = query + " AND " end
      query = query + " \n count(distinct ir_jaune.id) > " + search[:wjaune_cnt]
      need_having_clause = false
    end
    if (!search[:wsprinter_cnt].blank? && search[:wsprinter_cnt].to_i > 0)
      if (need_having_clause) then query = query + " HAVING " else query = query + " AND " end
      query = query + " \n count(distinct ir_sprinter.id) > " + search[:wsprinter_cnt]
      need_having_clause = false
    end
    if (!search[:wclimber_cnt].blank? && search[:wclimber_cnt].to_i > 0)
      if (need_having_clause) then query = query + " HAVING " else query = query + " AND " end
      query = query + " \n count(distinct ir_climber.id) > " + search[:wclimber_cnt]
      need_having_clause = false
    end
    if (!search[:pjaune_cnt].blank? && search[:pjaune_cnt].to_i > 0)
      if (need_having_clause) then query = query + " HAVING " else query = query + " AND " end
      query = query + " \n count(distinct is_jaune.id) > " + search[:pjaune_cnt]
      need_having_clause = false
    end
    if (!search[:psprinter_cnt].blank? && search[:psprinter_cnt].to_i > 0)
      if (need_having_clause) then query = query + " HAVING " else query = query + " AND " end
      query = query + " \n count(distinct is_sprinter.id) > " + search[:psprinter_cnt]
      need_having_clause = false
    end
    if (!search[:pclimber_cnt].blank? && search[:pclimber_cnt].to_i > 0)
      if (need_having_clause) then query = query + " HAVING " else query = query + " AND " end
      query = query + " \n count(distinct is_climber.id) > " + search[:pclimber_cnt]
      need_having_clause = false
    end
    if (!search[:wstage_cnt].blank? && search[:wstage_cnt].to_i > 0)
      if (need_having_clause) then query = query + " HAVING " else query = query + " AND " end
      query = query + " \n count(distinct is_stage.id) > " + search[:wstage_cnt]
      need_having_clause = false
    end
    Cyclist.find_by_sql(query)
  end


end
