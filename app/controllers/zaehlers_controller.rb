# encoding: UTF-8
class ZaehlersController < ApplicationController
  # GET /zaehlers
  # GET /zaehlers.json
  def index
    @zaehlers = Zaehler.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zaehlers, root: false } # liefert wg. serializer auch Werte
    end
  end

  # Werte normieren
  def normiertewerte
    @zaehlers = Zaehler.all
    a_werte = Array.new
    a_werte_normiert = Array.new
    a_series = Array.new
    @zaehlers.each do |zaehler|
      log("debug","Zähler id=#{zaehler.id} kurzbez=#{zaehler.kurzbezeichnung}")
      a_werte_normiert = werte_normieren(zaehler)
      # a_series << { "name" => zaehler.kurzbezeichnung, "data" => a_werte.sort_by{|x| x.x }, "id" => zaehler.id.to_s }
      pointRange = 24 * 3600 * 1000 * 30
      a_series << { "name" => zaehler.kurzbezeichnung, "id" => zaehler.id.to_s , "data" => a_werte_normiert.sort_by{|x| x.x }, "pointRange" => pointRange.to_s }
    end
    render json: a_series.to_json
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
      # format.json { render json: @zaehler, root: false } # liefert wg. serializer auch Werte
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

  private
  def werte_normieren(zaehler)
    a_werte_anhaengen = Array.new

    d_letzter_naechster = "2000-01-01".to_date
    a_werte_normiert = Array.new
    @werte = Wert.where("zaehler_id = ?", zaehler.id)

    # x = highchart Datum in millisecunden. y = Wert
    #a_werte = @werte.select('stand AS y, datum AS x')
    a_werte_normiert = @werte.select('stand AS y, datum AS x')
    #log("debug","#{a_werte_normiert.typeof}")
    # a_werte = @werte.select('stand AS y, unix_timestamp(datum)*1000 AS x')

    last_wert = a_werte_normiert[0].dup
    a_werte_normiert.each do |wert|
      # log("debug","wert.x=#{wert.x} last_wert.x=#{last_wert.x}");
      diff_X = (wert.x.to_date - last_wert.x.to_date).to_i # Differenz Tage zwischen zwei Werten
      if diff_X != 0
        diff_Y = wert.y.to_f - last_wert.y.to_f # Differenz Zählerstand zwischen zwei Werten
        diff_y = diff_Y / diff_X      # Differenz Zählerstand pro Tag
        monatserster = wert.x.to_date.at_beginning_of_month # Datum des Ersten im Monat
        next_monatserster = wert.x.to_date.next_month.at_beginning_of_month # Datum des Ersten im nächsten Monat
        diff_x_zum_monatsersten = wert.x.to_date - monatserster # Tage vom Wert zum ersten im Monat
        diff_y_zum_monatsersten = diff_x_zum_monatsersten.to_f * diff_y.to_f # Wert vom Ersten im Monat
        y_am_monatsersten = ( wert.y.to_f - diff_y_zum_monatsersten.to_f )
      end
      #if diff_X > 50
      #log("debug","x=#{wert.x} y=#{wert.y} last_x=#{last_wert.x} last_y=#{last_wert.y} diff_X=#{diff_X} diff_Y=#{diff_Y} diff_y=#{diff_y} monatserster=#{monatserster} next_monatserster=#{next_monatserster} diff_x_zum_monatsersten=#{diff_x_zum_monatsersten} diff_y_zum_monatsersten=#{diff_y_zum_monatsersten} y_am_monatsersten=#{y_am_monatsersten} ")

      #a_werte_anhaengen << set_wert( monatserster, y_am_monatsersten )
      #end
      last_wert = wert.dup
      #wert.x = wert.x.to_date.strftime("%Q").to_i
      #wert.y = wert.y.to_f
      wert.y = ("%.1f"%(wert.y - diff_y_zum_monatsersten)).to_f if !diff_y_zum_monatsersten.nil?
      if diff_x_zum_monatsersten.nil?
        wert.x = wert.x.to_date.strftime("%Q").to_i 
      else
        d_naechster = wert.x.to_date.at_beginning_of_month
        #log("debug","check(0, wert.x - diff_x_zum_monatsersten=#{wert.x - diff_x_zum_monatsersten},wert.y=#{wert.y},last_wert.x=#{last_wert.x},last_wert.y=#{last_wert.y}, d_letzter_naechster=#{d_letzter_naechster},diff_y=#{"%.f"%diff_y})")
        check(0, wert.x.to_date - diff_x_zum_monatsersten,wert.y.to_f,last_wert.x.to_date,last_wert.y.to_f, d_letzter_naechster,diff_y.to_f, a_werte_anhaengen )
        d_letzter_naechster = d_naechster
        wert.x = (wert.x.to_date - diff_x_zum_monatsersten).to_date.strftime("%Q").to_i
      end

    end
    a_werte_anhaengen.each do |w|
      log("debug", "w.x=#{w.x} w.y=#{w.y}")
      a_werte_normiert << w
    end
    #a_werte_normiert << a_werte_anhaengen
    return a_werte_normiert
  end

  def check(i,x,y,last_x, last_y,d_letzter_naechster,diff_y, a_werte_anhaengen )
    #log("debug","def check(i=#{i},x=#{x},y=#{y},last_x=#{last_x}, last_y=#{last_y},d_letzter_naechster=#{d_letzter_naechster},diff_y=#{diff_y})")
    i += 1
    prev_erster = x.prev_month.at_beginning_of_month # erster der vorherigen Monats
    dy = last_y - y
    dx = ( last_x - x ).to_i
    dxy = dy / dx
    y_neu = y-(dxy * ( x - prev_erster))
    if (((d_letzter_naechster < prev_erster) && (i < 9) && (d_letzter_naechster != "2000-01-01".to_date)) ||((d_letzter_naechster == prev_erster) && (i > 1)))
      #log("debug","+++Zaehler d_letzter_naechster=#{d_letzter_naechster} prev_prev_prev_erster=#{prev_erster} y=#{y} last_y=#{last_y} dy=#{dy} dx=#{dx} dy/dx=#{dxy} y_neu=#{y_neu} y-(dxy * ( x - prev_erster))= #{y-(dxy * ( x - prev_erster))} ")
      if (i > 1)
        log("debug", "i=#{i} x=#{x} y=#{y} d_letzter_naechster=#{d_letzter_naechster} prev_erster=#{prev_erster}")
        set_wert(x,"%.1f"%y,a_werte_anhaengen)
      end
      check(i,prev_erster,y_neu,x, y,d_letzter_naechster,diff_y, a_werte_anhaengen )
    end
  end

  def set_wert(x,y,a_werte_anhaengen)
    log("debug","set_wert(#{x}, #{y})");
    neuer_wert = Wert.select('stand AS y, datum AS x').limit(1).dup
    neuer_wert[0].x = x.to_date.strftime("%Q").to_i
    neuer_wert[0].y = y.to_f 
    log("debug","set_werte: neuer_wert[0].inspect=#{neuer_wert[0].inspect}");
    a_werte_anhaengen << neuer_wert[0]
  end
end
