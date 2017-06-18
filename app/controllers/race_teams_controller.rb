class RaceTeamsController < ApplicationController
  before_action :set_race_team, only: [:show, :edit, :update, :destroy]

  # GET /race_teams
  def index
    @race_teams = RaceTeam.all
  end

  # GET /race_teams/1
  def show
  end

  # GET /race_teams/new
  def new
    @race_team = RaceTeam.new
  end

  # GET /race_teams/1/edit
  def edit
  end

  # POST /race_teams
  def create
    #@race_team = RaceTeam.new(race_team_params)
    @race_team = RaceTeam.new(params.required(:race_team).permit!)

    if @race_team.save
      redirect_to @race_team, notice: 'Race team was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /race_teams/1
  def update
    if @race_team.update_attributes(params.required(:race_team).permit!)

      redirect_to @race_team, notice: 'Race team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /race_teams/1
  def destroy
    @race_team.destroy
    redirect_to race_teams_url, notice: 'Race team was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_race_team
      @race_team = RaceTeam.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def race_team_params
      params.fetch(:race_team, {})
    end
end
