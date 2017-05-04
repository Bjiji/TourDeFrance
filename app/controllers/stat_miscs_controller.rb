class StatMiscsController < ApplicationController
  # GET /stat_miscs
  # GET /stat_miscs.json
  def index
    @stat_misc_dnf = StatMisc.statDnf(params[:year])
    @tmp = StatMisc.statSuccStages(params[:year])

    @stat_misc_succ_stages = @tmp.map{|u| [Team.find(u['team']), Stage.find(u['stage1']), Stage.find(u['stage2']), Stage.find(u['stage3']), RaceRunner.find(u['runner1']), RaceRunner.find(u['runner2']), RaceRunner.find(u['runner3'])]}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stat_miscs }
    end
  end

  # GET /stat_miscs/1
  # GET /stat_miscs/1.json
  def show
    @stat_misc = StatMisc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stat_misc }
    end
  end

  # GET /stat_miscs/new
  # GET /stat_miscs/new.json
  def new
    @stat_misc = StatMisc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stat_misc }
    end
  end

  # GET /stat_miscs/1/edit
  def edit
    @stat_misc = StatMisc.find(params[:id])
  end

  # POST /stat_miscs
  # POST /stat_miscs.json
  def create
    @stat_misc = StatMisc.new(params[:stat_misc])

    respond_to do |format|
      if @stat_misc.save
        format.html { redirect_to @stat_misc, notice: 'Stat misc was successfully created.' }
        format.json { render json: @stat_misc, status: :created, location: @stat_misc }
      else
        format.html { render action: "new" }
        format.json { render json: @stat_misc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stat_miscs/1
  # PUT /stat_miscs/1.json
  def update
    @stat_misc = StatMisc.find(params[:id])

    respond_to do |format|
      if @stat_misc.update_attributes(params[:stat_misc])
        format.html { redirect_to @stat_misc, notice: 'Stat misc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stat_misc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stat_miscs/1
  # DELETE /stat_miscs/1.json
  def destroy
    @stat_misc = StatMisc.find(params[:id])
    @stat_misc.destroy

    respond_to do |format|
      format.html { redirect_to stat_miscs_url }
      format.json { head :no_content }
    end
  end
end
