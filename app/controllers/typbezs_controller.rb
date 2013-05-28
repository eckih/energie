class TypbezsController < ApplicationController
  # GET /typbezs
  # GET /typbezs.json
  def index
    @typbezs = Typbez.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @typbezs }
    end
  end

  # GET /typbezs/1
  # GET /typbezs/1.json
  def show
    @typbez = Typbez.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @typbez }
    end
  end

  # GET /typbezs/new
  # GET /typbezs/new.json
  def new
    @typbez = Typbez.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @typbez }
    end
  end

  # GET /typbezs/1/edit
  def edit
    @typbez = Typbez.find(params[:id])
  end

  # POST /typbezs
  # POST /typbezs.json
  def create
    @typbez = Typbez.new(params[:typbez])

    respond_to do |format|
      if @typbez.save
        format.html { redirect_to @typbez, notice: 'Typbez was successfully created.' }
        format.json { render json: @typbez, status: :created, location: @typbez }
      else
        format.html { render action: "new" }
        format.json { render json: @typbez.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /typbezs/1
  # PUT /typbezs/1.json
  def update
    @typbez = Typbez.find(params[:id])

    respond_to do |format|
      if @typbez.update_attributes(params[:typbez])
        format.html { redirect_to @typbez, notice: 'Typbez was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @typbez.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /typbezs/1
  # DELETE /typbezs/1.json
  def destroy
    @typbez = Typbez.find(params[:id])
    @typbez.destroy

    respond_to do |format|
      format.html { redirect_to typbezs_url }
      format.json { head :no_content }
    end
  end
end
