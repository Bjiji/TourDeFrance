class StagesController < ApplicationController
  # GET /stages
  # GET /stages.json
  def index

    if (params[:no_search] == 'true') then
      @stages = []
    elsif (params[:missing_results] == 'true') then
      @stages = Stage.missingResults()
    else
      @stages = Stage.search(params)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json {render :json => @stages}
    end
  end

  # GET /stages/1
  # GET /stages/1.json
  def show
    @stage = Stage.find(params[:id])
    @mountains = MountainStageResult.where(:stage_id => params[:id]).order('`order`')
    @previous_stage = nil
    @next_stage = nil
    if (@stage.ordinal != nil) then
      @previous_stage = Stage.where(:race_id => @stage.race.id, :ordinal => @stage.ordinal - 1).first()
      @next_stage = Stage.where(:race_id => @stage.race.id, :ordinal => @stage.ordinal + 1).first()
    end;
    @ite_stage_results_h = IteStageResult.where(:stage_id => params[:id])
    @yj_stage_results_h = YjStageResults.where(:stage_id => params[:id])
    if (@stage.route != nil) then
    @route = @stage.route.gsub(/\s+:\s+/, '<br>&nbsp;').gsub(/\s+-\s+/, '<br>&nbsp;')
    else
      @route = ""
    end
      respond_to do |format|
      format.html # show.html.erb
      format.json {render :json => @stage}
    end
  end

  # GET /stages/new
  # GET /stages/new.json
  def new
    @stage = Stage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json {render :json => @stage}
    end
  end

  # GET /stages/1/edit
  def edit
    @stage = Stage.find(params[:id])
  end

  # POST /stages
  # POST /stages.json
  def create
    @stage = Stage.new(params[:stage])

    respond_to do |format|
      if @stage.save
        format.html {redirect_to @stage, :notice => 'Stage was successfully created.'}
        format.json {render :json => @stage, :status => :created, :location => @stage}
      else
        format.html {render :action => "new"}
        format.json {render :json => @stage.errors, :status => :unprocessable_entity}
      end
    end
  end

  # PUT /stages/1
  # PUT /stages/1.json
  def update
    @stage = Stage.find(params[:id])

    respond_to do |format|
      if @stage.update_attributes(params[:stage])
        format.html {redirect_to @stage, :notice => 'Stage was successfully updated.'}
        format.json {head :no_content}
      else
        format.html {render :action => "edit"}
        format.json {render :json => @stage.errors, :status => :unprocessable_entity}
      end
    end
  end

  # DELETE /stages/1
  # DELETE /stages/1.json
  def destroy
    @stage = Stage.find(params[:id])
    @stage.destroy

    respond_to do |format|
      format.html {redirect_to stages_url}
      format.json {head :no_content}
    end
  end
end
