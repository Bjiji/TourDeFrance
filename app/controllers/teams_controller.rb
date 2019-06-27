class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.json
  def index

    if (params[:year] != nil) then
      year = params[:year];
    else
      year = Race.maximum('year')
    end
    @teams = Team.joins(:races).where(:races => {:year => year}).select('distinct teams.*')


    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = Team.find(params[:id])
    @race_runners = @team.race_runners.order(year: :desc, number: :asc)
    @race_teams = @team.race_teams.order(year: :desc)
    @cyclists = @team.cyclists
    @ite_stage_results = IteStageResult.joins(race_runner: :race_team).where(:race_teams => {:team_id => params[:id]})
    @r_victories = @team.race_victories
    @rc_victories = IgRaceResult.joins(climber: :race_team).where(:race_teams => {:team_id => params[:id]}).order(year: :DESC)
    @rs_victories =IgRaceResult.joins(sprinter: :race_team).where(:race_teams => {:team_id => params[:id]}).order(year: :DESC)
    @ry_victories = IgRaceResult.joins(young: :race_team).where(:race_teams => {:team_id => params[:id]}).order(year: :DESC)
    @s_victories = @team.stage_victories
    @y_jersey = IgStageResult.joins(leader: :race_team).joins(:stage).where(:race_teams => {:team_id => params[:id]}).order("stages.year DESC, stages.ordinal DESC")
    @c_jersey = IgStageResult.joins(climber: :race_team).joins(:stage).where(:race_teams => {:team_id => params[:id]}).order("stages.year DESC, stages.ordinal DESC")
    @s_jersey = IgStageResult.joins(sprinter: :race_team).joins(:stage).where(:race_teams => {:team_id => params[:id]}).order("stages.year DESC, stages.ordinal DESC")
    @yy_jersey = IgStageResult.joins(young: :race_team).joins(:stage).where(:race_teams => {:team_id => params[:id]}).order("stages.year DESC, stages.ordinal DESC")


    @r_podium = YjStageResults.joins(race_runner: :race_team).joins(:stage).where("stages.is_last = true AND race_teams.team_id = ? AND pos <= 3", params[:id]).order("year DESC")

    @rt_victories = IgRaceResult.joins(:race_team).where(:race_teams => {:team_id => params[:id]}).order(year: :DESC)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(params.required(:team).permit!)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params.required(:team).permit!)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
end
