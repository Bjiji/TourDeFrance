class RaceRunnersController < ApplicationController
  # GET /race_runners
  # GET /race_runners.json
  def index
    #@race_runners = RaceRunner.all
    @race_runners = RaceRunner.joins(:race).joins(:team).where(:teams => {:id => params[:team]}, :races => {:year => params[:year]})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @race_runners }
    end
  end

  # GET /race_runners/1
  # GET /race_runners/1.json
  def show
    @race_runner = RaceRunner.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @race_runner }
    end
  end

  # GET /race_runners/new
  # GET /race_runners/new.json
  def new
    @race_runner = RaceRunner.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @race_runner }
    end
  end

  # GET /race_runners/1/edit
  def edit
    @race_runner = RaceRunner.find(params[:id])
  end

  # POST /race_runners
  # POST /race_runners.json
  def create
    @race_runner = RaceRunner.new(params[:race_runner])

    respond_to do |format|
      if @race_runner.save
        format.html { redirect_to @race_runner, :notice => 'Race runner was successfully created.' }
        format.json { render :json => @race_runner, :status => :created, :location => @race_runner }
      else
        format.html { render :action => "new" }
        format.json { render :json => @race_runner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /race_runners/1
  # PUT /race_runners/1.json
  def update
    @race_runner = RaceRunner.find(params[:id])

    respond_to do |format|
      if @race_runner.update_attributes(params[:race_runner])
        format.html { redirect_to @race_runner, :notice => 'Race runner was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @race_runner.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /race_runners/1
  # DELETE /race_runners/1.json
  def destroy
    @race_runner = RaceRunner.find(params[:id])
    @race_runner.destroy

    respond_to do |format|
      format.html { redirect_to race_runners_url }
      format.json { head :no_content }
    end
  end
end
