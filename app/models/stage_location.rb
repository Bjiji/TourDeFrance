class StageLocation < ActiveRecord::Base
  has_many :stages_start, :foreign_key => "start_location", :class_name => "Stage"
  has_many :stages_finish, :foreign_key => "finish_location", :class_name => "Stage"


  def stages
    stages_start | stages_finish
  end

end
