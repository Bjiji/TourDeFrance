class StatStageDiffsController < ApplicationController
  # GET /stat_stage_diffs
  # GET /stat_stage_diffs.json
  def index
    if (params[:no_search] != 'true') then
      @stat_stage_diffs = StatStageDiff.search(params)
      end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stat_stage_diffs }
    end
  end

end
