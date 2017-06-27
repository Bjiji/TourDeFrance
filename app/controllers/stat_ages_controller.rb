class StatAgesController < ApplicationController

  def index
    limit = params[:limit]
    nationality = params[:nationality]
    year = params[:year]
    tmp = StatMisc.stage_age("stage_winner_id", "asc", limit, nationality, year);
    @stage_winner_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.stage_age("leader_id", "asc", limit, nationality, year);
     @stage_leader_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

     tmp = StatMisc.stage_age("sprinter_id", "asc", limit, nationality, year);
     @stage_sprinter_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

     tmp = StatMisc.stage_age("climber_id", "asc", limit, nationality, year);
     @stage_climber_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

     tmp = StatMisc.stage_age("young_id", "asc", limit, nationality, year);
     @stage_young_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("leader_id", "asc", limit, nationality, year);
    @race_leader_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("sprinter_id", "asc", limit, nationality, year);
    @race_sprinter_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("climber_id", "asc", limit, nationality, year);
    @race_climber_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("young_id", "asc", limit, nationality, year);
    @race_young_young = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}



    tmp = StatMisc.stage_age("stage_winner_id", "desc", limit, nationality, year);
    @stage_winner_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.stage_age("leader_id", "desc", limit, nationality, year);
    @stage_leader_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.stage_age("sprinter_id", "desc", limit, nationality, year);
    @stage_sprinter_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.stage_age("climber_id", "desc", limit, nationality, year);
    @stage_climber_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.stage_age("young_id", "desc", limit, nationality, year);
    @stage_young_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgStageResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("leader_id", "desc", limit, nationality, year);
    @race_leader_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("sprinter_id", "desc", limit, nationality, year);
    @race_sprinter_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("climber_id", "desc", limit, nationality, year);
    @race_climber_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

    tmp = StatMisc.race_age("young_id", "desc", limit, nationality, year);
    @race_young_old = tmp.map{|u| [u['day_age'], Cyclist.find(u['c_id']), IgRaceResult.find(u['ig_id']), Stage.find(u['s_id']), Race.find(u['r_id'])]}

  end

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
end
