class YjStageResultsController < ApplicationController
  before_action :set_yj_stage_result, only: [:show, :edit, :update, :destroy]

  # GET /yj_stage_results
  def index
    @yj_stage_results = YjStageResults.all
  end

  # GET /yj_stage_results/1
  def show
  end

  # GET /yj_stage_results/new
  def new
    @yj_stage_result = YjStageResults.new
  end

  # GET /yj_stage_results/1/edit
  def edit
    def edit
      @yj_stage_result = YjStageResults.find(params[:id])
    end
  end

  # POST /yj_stage_results
  def create
    @yj_stage_result = YjStageResults.new(yj_stage_result_params)

    if @yj_stage_result.save
      redirect_to @yj_stage_result, notice: 'Yj stage results was successfully created.'
    else
      render :new
    end
  end

  def update
    @yj_stage_result = YjStageResults.find(params[:id])

    respond_to do |format|
      if @yj_stage_result.update_attributes(params.required(:yj_stage_results).permit!)
        format.html {redirect_to @yj_stage_result, :notice => 'yj stage result was successfully updated.'}
        format.json {head :no_content}
      else
        format.html {render :action => "edit"}
        format.json {render :json => @yj_stage_result.errors, :status => :unprocessable_entity}
      end
    end
  end

  # DELETE /yj_stage_results/1
  def destroy
    @yj_stage_result.destroy
    redirect_to yj_stage_results_index_url, notice: 'Yj stage results was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yj_stage_result
      @yj_stage_result = YjStageResults.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def yj_stage_result_params
      params.fetch(:yj_stage_result, {})
    end
end
