# encoding: UTF-8
class WerteController < ApplicationController
  # GET /werte
  # GET /werte.json
  def index
    @werte = Wert.all
    @zaehler = Zaehler.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @werte }
    end
  end
  
  # GET /werte/1
  # GET /werte/1.json
  def show
    @wert = Wert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wert }
    end
  end
  
  def eingabe
    
    @zaehlers = Zaehler.all
    @arr = Array.new(@zaehlers.size)
    for @zaehler in @zaehlers
      @arr[@zaehlers.index(@zaehler)] = Wert.create(zaehler_id: @zaehler.id,datum: Date.today)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zaehler }
    end
  end

  # GET /werte/new
  # GET /werte/new.json
  def new
    @wert = Wert.new
    @zaehler = Zaehler.all
    @lastWert = Wert.last

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wert }
    end
  end

  # GET /werte/1/edit
  def edit
    @wert = Wert.find(params[:id])
  end

  # POST /werte
  # POST /werte.json
  def create
    @wert = Wert.new(params[:wert])
    @wert.zaehler_id = params[:zaehler_id][:id]

    respond_to do |format|
      if @wert.save
        format.html { redirect_to @wert, notice: 'Wert wurde erfolgreich eingetragen.' }
        format.json { render json: @wert, status: :created, location: @wert }
      else
        format.html { render action: "new" }
        format.json { render json: @wert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /werte/1
  # PUT /werte/1.json
  def _update
    @wert = Wert.find(params[:id])

    respond_to do |format|
      if @wert.update_attributes(params[:wert])
        format.html { redirect_to @wert, notice: 'Wert wurde erfolgreich geändert.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wert.errors, status: :unprocessable_entity }
      end
    end
  end
  
def update
  @wert = Wert.find(params[:id])

  respond_to do |format|
      if @wert.update_attributes(params[:wert])
        format.html { redirect_to @wert, notice: 'Wert wurde erfolgreich geändert.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@wert) }
      end
  end
end

  # DELETE /werte/1
  # DELETE /werte/1.json
  def destroy
    @wert = Wert.find(params[:id])
    @wert.destroy

    respond_to do |format|
      format.html { redirect_to werte_url }
      format.json { head :no_content }
    end
  end
end
