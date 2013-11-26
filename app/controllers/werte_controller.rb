# encoding: UTF-8
class WerteController < ApplicationController

  # GET /werte
  # GET /werte.json
  def index
    log("debug","")
    @werte = Wert.order("id ASC")
    @zaehler = Zaehler.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @werte }
    end
  end
  
  # GET /werte/1
  # GET /werte/1.json
  def show
    log("debug","")
    @wert = Wert.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wert }
    end
  end
  
  def eingabe
    log("debug","")
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
    log("debug","")
    @wert = Wert.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wert }
    end
    
  end
  
  def new_wertesatz
    log("debug","")
    @wert = Wert.new
    @zaehlers = Zaehler.all
    @lastWert = Wert.last

    @arr = Array.new(@zaehlers.size)
    for @zaehler in @zaehlers
      @arr[@zaehlers.index(@zaehler)] = Wert.create(zaehler_id: @zaehler.id,datum: Date.today)
    end

    redirect_to werte_url, notice: 'Werte wurden erfolgreich erstellt.'

  end

  # GET /werte/1/edit
  def edit
    log("debug","")
    @wert = Wert.find(params[:id])
  end

  # POST /werte
  # POST /werte.json
  def create
    log("debug","")
    @wert = Wert.new(params[:wert])
    @wert.zaehler_id = params[:zaehler_id]
    @wert.datum = Date.today

    respond_to do |format|
      if @wert.save
        format.html { redirect_to werte_url, notice: 'Wert wurde erfolgreich erstellt.' }
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
    log("debug","")
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
  log("debug","")
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
    log("debug","")
    @wert = Wert.find(params[:id])
    @wert.destroy

    respond_to do |format|
      format.html { redirect_to werte_url }
      format.json { head :no_content }
    end
  end

  def destroy_checked
    log("debug","")
    @werte = Wert.find(params[:wert_ids])
    @werte.each {|wert| wert.destroy }

    respond_to do |format|
      format.html { redirect_to werte_url }
      format.json { head :no_content }
    end    
  end

  def mehrere
    log("debug","")
    #@werte = Wert.find(params[:wert_ids])
    case params[:commit]
    when "Datum von gecheckten Werten ändern"
      redirect_to :action => 'datum_mehrere_aendern', :wert_ids => params[:wert_ids]
    when "gecheckte Werte löschen"
      redirect_to :action => 'destroy_checked', :wert_ids => params[:wert_ids]
    end
  end
  
  def datum_mehrere_aendern
    log("debug","#{params[:commit]}")
    if params[:wert_ids].nil?
      flash[:notice] = "Keine Werte gechecked!"
    else
      @werte = Wert.find(params[:wert_ids])
      @werte.each { |wert|
        log("debug","#{wert.id} #{@werte.first.datum}")
        wert.update_attribute(:datum, @werte.first.datum)
        }
      flash[:notice] = "Datum mehrerer Felder in #{@werte.first.datum.strftime("%d.%m.%Y")} geändert"
    end
      
      redirect_to werte_url
  end
  
  def update_mehrere
    log("debug","")
    @werte = Wert.update(params[:werte].keys, params[:werte].values)
    if @werte.empty?
      flash[:notice] = "Werte updated"
      redirect_to werte_url
    else
      render :action => "mehrere"
    end
  end
  
end
