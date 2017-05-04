class DatesController < ApplicationController
  # GET /dates
  # GET /dates.json
  def index
    @cyclists = Cyclist.birthday()

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dates }
    end
  end

  # GET /dates/1
  # GET /dates/1.json
  def show
    @date = Date.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @date }
    end
  end

  # GET /dates/new
  # GET /dates/new.json
  def new
    @date = Date.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @date }
    end
  end

  # GET /dates/1/edit
  def edit
    @date = Date.find(params[:id])
  end

  # POST /dates
  # POST /dates.json
  def create
    @date = Date.new(params[:date])

    respond_to do |format|
      if @date.save
        format.html { redirect_to @date, notice: 'Date was successfully created.' }
        format.json { render json: @date, status: :created, location: @date }
      else
        format.html { render action: "new" }
        format.json { render json: @date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dates/1
  # PUT /dates/1.json
  def update
    @date = Date.find(params[:id])

    respond_to do |format|
      if @date.update_attributes(params[:date])
        format.html { redirect_to @date, notice: 'Date was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dates/1
  # DELETE /dates/1.json
  def destroy
    @date = Date.find(params[:id])
    @date.destroy

    respond_to do |format|
      format.html { redirect_to dates_url }
      format.json { head :no_content }
    end
  end
end
