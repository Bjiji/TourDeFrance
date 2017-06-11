class IteStageResultsController < ApplicationController
  # GET /ite_stage_results
  # GET /ite_stage_results.json
  def index
    if (params[:no_search] != 'true') then
      @ite_stage_results = IteStageResult.search(params)
    else
      @ite_stage_results = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ite_stage_results }
    end
  end

  # GET /ite_stage_results/1
  # GET /ite_stage_results/1.json
  def show
    @ite_stage_result = IteStageResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @ite_stage_result }
    end
  end

  # GET /ite_stage_results/new
  # GET /ite_stage_results/new.json
  def new
    @ite_stage_result = IteStageResult.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @ite_stage_result }
    end
  end

  # GET /ite_stage_results/1/edit
  def edit
    @ite_stage_result = IteStageResult.find(params[:id])
  end

  # POST /ite_stage_results
  # POST /ite_stage_results.json
  def create
    @ite_stage_result = IteStageResult.new(params.required(:ite_stage_result).permit!)

    respond_to do |format|
      if @ite_stage_result.save
        format.html { redirect_to @ite_stage_result, :notice => 'Ite stage result was successfully created.' }
        format.json { render :json => @ite_stage_result, :status => :created, :location => @ite_stage_result }
      else
        format.html { render :action => "new" }
        format.json { render :json => @ite_stage_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ite_stage_results/1
  # PUT /ite_stage_results/1.json
  def update
    @ite_stage_result = IteStageResult.find(params[:id])

    respond_to do |format|
      if @ite_stage_result.update_attributes(params.required(:ite_stage_result).permit!)
        format.html { redirect_to @ite_stage_result, :notice => 'Ite stage result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ite_stage_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ite_stage_results/1
  # DELETE /ite_stage_results/1.json
  def destroy
    @ite_stage_result = IteStageResult.find(params[:id])
    @ite_stage_result.destroy

    respond_to do |format|
      format.html { redirect_to ite_stage_results_url }
      format.json { head :no_content }
    end
  end
end
