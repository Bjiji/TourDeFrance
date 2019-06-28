class OtherRacesController < ApplicationController
  before_action :set_other_race, only: [:show, :edit, :update, :destroy]

  # GET /other_races
  def index
    @other_races = OtherRace.all
  end

  # GET /other_races/1
  def show
  end

  # GET /other_races/new
  def new
    @other_race = OtherRace.new
  end

  # GET /other_races/1/edit
  def edit
  end

  # POST /other_races
  def create
    @other_race = OtherRace.new(other_race_params)

    if @other_race.save
      redirect_to @other_race, notice: 'Other race was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /other_races/1
  def update
    if @other_race.update(other_race_params)
      redirect_to @other_race, notice: 'Other race was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /other_races/1
  def destroy
    @other_race.destroy
    redirect_to other_races_url, notice: 'Other race was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_other_race
      @other_race = OtherRace.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def other_race_params
      params.require(:other_race).permit(:cyclist_id, :year, :race_name, :race_label)
    end
end
