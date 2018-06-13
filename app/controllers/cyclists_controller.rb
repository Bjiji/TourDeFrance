class CyclistsController < ApplicationController
  # GET /cyclists
  # GET /cyclists.json

  def index
    if (params[:no_search] != 'true') then
      @cyclists = Cyclist.search(params)
    else
      @cyclists = []
    end
    @search=""
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cyclists }
    end
  end

  # GET /cyclists/1
  # GET /cyclists/1.json
  def show
    @cyclist = Cyclist.find(params[:id])
    @runs = RaceRunner.joins(:cyclist).where(:cyclists => {:id => params[:id]}).order(year: :DESC)
    @r_victories = IgRaceResult.joins(:leader).where(:race_runners => {:cyclist_id => params[:id]}).order(year: :DESC)
    @rc_victories = IgRaceResult.joins(:climber).where(:race_runners => {:cyclist_id => params[:id]}).order(year: :DESC)
    @rs_victories =IgRaceResult.joins(:sprinter).where(:race_runners => {:cyclist_id => params[:id]}).order(year: :DESC)
    @ry_victories = IgRaceResult.joins(:young).where(:race_runners => {:cyclist_id => params[:id]}).order(year: :DESC)


    @s_victories = IgStageResult.joins(:stage_winner).joins(:stage).where(:race_runners => { :cyclist_id => params[:id]}).order("year DESC, stages.ordinal DESC")
    @y_jersey = IgStageResult.joins(:leader).joins(:stage).where(:race_runners => { :cyclist_id => params[:id]}).order("year DESC, stages.ordinal DESC")
    @c_jersey = IgStageResult.joins(:climber).joins(:stage).where(:race_runners => { :cyclist_id => params[:id]}).order("year DESC, stages.ordinal DESC")
    @s_jersey = IgStageResult.joins(:sprinter).joins(:stage).where(:race_runners => { :cyclist_id => params[:id]}).order("year DESC, stages.ordinal DESC")
    @yg_jersey = IgStageResult.joins(:young).joins(:stage).where(:race_runners => { :cyclist_id => params[:id]}).order("year DESC, stages.ordinal DESC")

    @r_podium = YjStageResults.joins(:race_runner).joins(:stage).where("stages.is_last = true AND race_runners.cyclist_id = ? AND pos <= 3", params[:id]).order("year DESC")

#    @race = Race.where(:cyclist)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cyclist }
    end
  end

  # GET /cyclists/new
  # GET /cyclists/new.json
  def new
    @cyclist = Cyclist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cyclist }
    end
  end

  # GET /cyclists/1/edit
  def edit
    @cyclist = Cyclist.find(params[:id])
  end

  # POST /cyclists
  # POST /cyclists.json
  def create
    @cyclist = Cyclist.new(params[:cyclist].permit!)

    respond_to do |format|
      if @cyclist.save
        format.html { redirect_to @cyclist, :notice => 'Cyclist was successfully created.' }
        format.json { render :json => @cyclist, :status => :created, :location => @cyclist }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cyclist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cyclists/1
  # PUT /cyclists/1.json
  def update
    @cyclist = Cyclist.find(params[:id])

    respond_to do |format|
      if @cyclist.update_attributes(params.required(:cyclist).permit!)
        format.html { redirect_to @cyclist, :notice => 'Cyclist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cyclist.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cyclists/1
  # DELETE /cyclists/1.json
  def destroy
    @cyclist = Cyclist.find(params[:id])
    @cyclist.destroy

    respond_to do |format|
      format.html { redirect_to cyclists_url }
      format.json { head :no_content }
    end
  end

  def normalizeName
    Cyclist.normalize()
  end

  def search
    @cyclists = Cyclist.search(params)
  end
end
