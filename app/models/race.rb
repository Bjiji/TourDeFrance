class Race < ActiveRecord::Base
  attr_accessible :averageSpeed, :description, :distance, :name, :poolPrize, :winnerPrize, :year, :cyclist, :cyclist_id
  belongs_to :cyclist
  has_many :race_runners
  has_many :cyclists ,:through => :race_runners

end
