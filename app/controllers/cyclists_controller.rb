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
    @runs = RaceRunner.joins(:cyclist).where(:cyclists => {:id => params[:id]})
    @r_victories = IgRaceResult.find_by_leader(params[:id])
    @rc_victories = IgRaceResult.find_by_climber(params[:id])
    @rs_victories = IgRaceResult.find_by_sprinter(params[:id])
    @ry_victories = IgRaceResult.find_by_young(params[:id])
    @s_victories = IgStageResult.joins(:stage_winner).where(:race_runners => { :cyclist_id => params[:id]})
    @y_jersey = IgStageResult.joins(:leader).where(:race_runners => { :cyclist_id => params[:id]})
    @c_jersey = IgStageResult.joins(:climber).where(:race_runners => { :cyclist_id => params[:id]})
    @s_jersey = IgStageResult.joins(:sprinter).where(:race_runners => { :cyclist_id => params[:id]})
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
    @cyclist = Cyclist.new(params[:cyclist])

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
      if @cyclist.update_attributes(params[:cyclist])
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
