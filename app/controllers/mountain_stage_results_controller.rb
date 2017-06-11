class MountainStageResultsController < ApplicationController
  # GET /mountain_stage_results
  # GET /mountain_stage_results.json
  def index
    if (params[:no_search] != 'true') then
      @mountain_stage_results = MountainStageResult.search(params)
    else
      @mountain_stage_results = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @mountain_stage_results }
    end
  end

  # GET /mountain_stage_results/1
  # GET /mountain_stage_results/1.json
  def show
    @mountain_stage_result = MountainStageResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mountain_stage_result }
    end
  end

  # GET /mountain_stage_results/new
  # GET /mountain_stage_results/new.json
  def new
    @mountain_stage_result = MountainStageResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mountain_stage_result }
    end
  end

  # GET /mountain_stage_results/1/edit
  def edit
    @mountain_stage_result = MountainStageResult.find(params[:id])
  end

  # POST /mountain_stage_results
  # POST /mountain_stage_results.json
  def create
    @mountain_stage_result = MountainStageResult.new(params.required(:mountain_stage_result).permit!)

    respond_to do |format|
      if @mountain_stage_result.save
        format.html { redirect_to @mountain_stage_result, notice: 'Mountain stage result was successfully created.' }
        format.json { render json: @mountain_stage_result, status: :created, location: @mountain_stage_result }
      else
        format.html { render action: "new" }
        format.json { render json: @mountain_stage_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /mountain_stage_results/1
  # PUT /mountain_stage_results/1.json
  def update
    @mountain_stage_result = MountainStageResult.find(params[:id])

    respond_to do |format|
      if @mountain_stage_result.update_attributes(params.required(:mountain_stage_result).permit!)
        format.html { redirect_to @mountain_stage_result, notice: 'Mountain stage result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mountain_stage_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mountain_stage_results/1
  # DELETE /mountain_stage_results/1.json
  def destroy
    @mountain_stage_result = MountainStageResult.find(params[:id])
    @mountain_stage_result.destroy

    respond_to do |format|
      format.html { redirect_to mountain_stage_results_url }
      format.json { head :no_content }
    end
  end
end
