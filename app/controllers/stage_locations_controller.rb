class StageLocationsController < ApplicationController
  before_action :set_stage_location, only: [:show, :edit, :update, :destroy]

  # GET /stage_locations
  def index
    @stage_locations = StageLocation.order(:name).all
  end

  # GET /stage_locations/1
  def show
  end

  # GET /stage_locations/new
  def new
    @stage_location = StageLocation.new
  end

  # GET /stage_locations/1/edit
  def edit
  end


  # POST /stage_locations
  def create
    @stage_location = StageLocation.new(stage_location_params.permit!)

    if @stage_location.save
      redirect_to @stage_location, notice: 'Stage location was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stage_locations/1
  def update
    if @stage_location.update(stage_location_params)
      redirect_to @stage_location, notice: 'Stage location was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /stage_locations/1
  def destroy
    @stage_location.destroy
    redirect_to stage_locations_url, notice: 'Stage location was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_stage_location
    @stage_location = StageLocation.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def stage_location_params
    params.fetch(:stage_location, {})
  end
end
