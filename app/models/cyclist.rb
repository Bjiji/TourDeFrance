class Cyclist < ActiveRecord::Base
  attr_accessible :description, :dob, :firstname, :lastname, :nationality, :pob, :tag, :races
  has_many :race_runners
  has_many :races ,:through => :race_runners
  has_many :ite_stage_results, :through => :race_runners

  def display_name
    display_name = lastname.upcase + " " + firstname
  end

end
