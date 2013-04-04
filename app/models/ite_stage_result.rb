 class IteStageResult < ActiveRecord::Base
  attr_accessible :diff_time_sec, :dnf, :dnq, :dns, :pos, :time_sec
  belongs_to :stage
  belongs_to :race_runner


  def display_time
    if (time_sec == nil || time_sec == 0) then
      str_time_sec  = " - "
    else
      str_time_sec = ChronicDuration.output(time_sec)
    end
    if (diff_time_sec == nil) then
      str_diff_time_sec  = " - "
    else
      str_diff_time_sec = (diff_time_sec / 60).to_s + "'" + (diff_time_sec % 60).to_s + "''"
    end
    # display_time = str_time_sec + ' (' + str_diff_time_sec + ')'
    display_time = str_diff_time_sec
  end

  def display_tag
    display_tag = ""
    if (dns == true)
      display_tag = " dns"
    end
    if (dnf == true)
      display_tag = display_tag + " dnf"
    end
    if (dnq == true)
      display_tag = display_tag + " dnq"
    end

  end

end
