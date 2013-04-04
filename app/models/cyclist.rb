class Cyclist < ActiveRecord::Base
  attr_accessible :description, :dob, :firstname, :lastname, :nationality, :pob, :tag, :races
  has_many :race_runners
  has_many :teams, :through => :race_runners
  has_many :races ,:through => :race_runners
  has_many :ite_stage_results, :through => :race_runners

  def display_name
    display_name = lastname.upcase + " " + firstname
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


    Cyclist.joins(:teams).all(:select => 'distinct cyclists.*', :conditions => ['teams.name LIKE ? AND cyclists.nationality LIKE ? AND cyclists.lastname LIKE ? AND cyclists.firstname LIKE ?', team_condition, nat_condition, lastname_condition, firstname_condition])

  end

end
