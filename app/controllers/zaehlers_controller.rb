# encoding: UTF-8
class ZaehlersController < ApplicationController
  # GET /zaehlers
  # GET /zaehlers.json
  def index
    @zaehlers = Zaehler.all
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zaehlers }
    end
  end

  # GET /zaehlers/1
  # GET /zaehlers/1.json
  def show
    @zaehler = Zaehler.find(params[:id])
    @typenbez = Typbez.all
		@werte = Wert.where("zaehler_id = ?", params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => { :zaehler => @zaehler, :werte => @werte} }
    end
  end
  
  # GET /zaehlers/new
  # GET /zaehlers/new.json
  def new
    @zaehler = Zaehler.new
    @typen = Typ.all
    @typenbez = Typbez.all
   @lastZaehler = Zaehler.last
   # 3.times { @zaehler.werte.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @zaehler }
    end
  end

  # GET /zaehlers/1/edit
  def edit
    @zaehler = Zaehler.find(params[:id])
    @typen = Typ.all
    @typenbez = Typbez.all
    @lastZaehler = Zaehler.last
  end

  # POST /zaehlers
  # POST /zaehlers.json
  def create
    @zaehler = Zaehler.new(params[:zaehler])
    @zaehler.typ_id = params[:typ_id]

    respond_to do |format|
      if @zaehler.save
        format.html { redirect_to zaehlers_url, notice: 'Zähler ' + @zaehler.bezeichnung + ' Nr:' + @zaehler.nummer.to_s + ' wurde erfolgreich erstellt.' }
        format.json { render json: @zaehler, status: :created, location: @zaehler }
      else
        format.html { render action: "new" }
        format.json { render json: @zaehler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /zaehlers/1
  # PUT /zaehlers/1.json
  def update
    @zaehler = Zaehler.find(params[:id])

    respond_to do |format|
      if @zaehler.update_attributes(params[:zaehler])
        format.html { redirect_to zaehlers_url, notice: 'Zähler ' + @zaehler.bezeichnung + ' Nr:' + @zaehler.nummer.to_s + ' wurde erfolgreich geändert.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @zaehler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zaehlers/1
  # DELETE /zaehlers/1.json
  def destroy
    @zaehler = Zaehler.find(params[:id])
    @zaehler.destroy

    respond_to do |format|
      format.html { redirect_to zaehlers_url }
      format.json { head :no_content }
    end
  end
  
  def jsontest
    @zaehler = Zaehler.first
    @werte = Wert.find_all_by_zaehler_id(66)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @werte }
    end    
  end  
    
end
