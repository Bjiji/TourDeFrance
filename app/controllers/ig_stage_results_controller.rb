class IgStageResultsController < ApplicationController
  # GET /ig_stage_results
  # GET /ig_stage_results.json
  def index
    @ig_stage_results = IgStageResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ig_stage_results }
    end
  end

  # GET /ig_stage_results/1
  # GET /ig_stage_results/1.json
  def show
    @ig_stage_result = IgStageResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ig_stage_result }
    end
  end

  # GET /ig_stage_results/new
  # GET /ig_stage_results/new.json
  def new
    @ig_stage_result = IgStageResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ig_stage_result }
    end
  end

  # GET /ig_stage_results/1/edit
  def edit
    @ig_stage_result = IgStageResult.find(params[:id])
  end

  # POST /ig_stage_results
  # POST /ig_stage_results.json
  def create
    @ig_stage_result = IgStageResult.new(params[:ig_stage_result])

    respond_to do |format|
      if @ig_stage_result.save
        format.html { redirect_to @ig_stage_result, notice: 'Ig stage result was successfully created.' }
        format.json { render json: @ig_stage_result, status: :created, location: @ig_stage_result }
      else
        format.html { render action: "new" }
        format.json { render json: @ig_stage_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ig_stage_results/1
  # PUT /ig_stage_results/1.json
  def update
    @ig_stage_result = IgStageResult.find(params[:id])

    respond_to do |format|
      if @ig_stage_result.update_attributes(params[:ig_stage_result])
        format.html { redirect_to @ig_stage_result, notice: 'Ig stage result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ig_stage_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ig_stage_results/1
  # DELETE /ig_stage_results/1.json
  def destroy
    @ig_stage_result = IgStageResult.find(params[:id])
    @ig_stage_result.destroy

    respond_to do |format|
      format.html { redirect_to ig_stage_results_url }
      format.json { head :no_content }
    end
  end
end
