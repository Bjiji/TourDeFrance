class OtherRace < ApplicationRecord
  belongs_to :cyclist

  def full_display
    return race_display + " : " + cyclist.display_name
  end

  def race_display
    return "#{race_label} (#{year})"
  end
end
