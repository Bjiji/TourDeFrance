class IgRaceResultsController < ApplicationController
  # GET /ig_race_results
  # GET /ig_race_results.json
  def index
    @ig_race_results = IgRaceResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ig_race_results }
    end
  end

  # GET /ig_race_results/1
  # GET /ig_race_results/1.json
  def show
    @ig_race_result = IgRaceResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ig_race_result }
    end
  end

  # GET /ig_race_results/new
  # GET /ig_race_results/new.json
  def new
    @ig_race_result = IgRaceResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ig_race_result }
    end
  end

  # GET /ig_race_results/1/edit
  def edit
    @ig_race_result = IgRaceResult.find(params[:id])
  end

  # POST /ig_race_results
  # POST /ig_race_results.json
  def create
    @ig_race_result = IgRaceResult.new(params[:ig_race_result])

    respond_to do |format|
      if @ig_race_result.save
        format.html { redirect_to @ig_race_result, notice: 'Ig race result was successfully created.' }
        format.json { render json: @ig_race_result, status: :created, location: @ig_race_result }
      else
        format.html { render action: "new" }
        format.json { render json: @ig_race_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ig_race_results/1
  # PUT /ig_race_results/1.json
  def update
    @ig_race_result = IgRaceResult.find(params[:id])

    respond_to do |format|
      if @ig_race_result.update_attributes(params[:ig_race_result])
        format.html { redirect_to @ig_race_result, notice: 'Ig race result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ig_race_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ig_race_results/1
  # DELETE /ig_race_results/1.json
  def destroy
    @ig_race_result = IgRaceResult.find(params[:id])
    @ig_race_result.destroy

    respond_to do |format|
      format.html { redirect_to ig_race_results_url }
      format.json { head :no_content }
    end
  end
end
