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
    a_series = Array.new
    @zaehlers.each do |zaehler|
      a_werte = werte_normieren(zaehler)
      a_series << { "name" => zaehler.kurzbezeichnung, "data" => a_werte, "id" => zaehler.id }
      log("debug","#{a_werte}")
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
    verbrauch_berechnen(zaehler)

    @werte = Wert.where("zaehler_id = ?", zaehler.id)
    a_werte = @werte.select('stand AS y, datum AS x')
    # a_werte = @werte.select('stand AS y, unix_timestamp(datum)*1000 AS x')

    a_werte.each do |wert|
      wert.x = wert.x.to_date.strftime("%Q").to_i
      wert.y = wert.y.to_f
      #log("debug","x=#{wert.x} y=#{wert.y}")
    end
    return a_werte
  end

  def verbrauch_berechnen(zaehler)
    i = 0
    d_letzter_naechster = 0
    letzter_diff_stand = 0
    letzter_stand = zaehler.werte[0].stand
    letztes_datum = zaehler.werte[0].datum
    ld("Id=#{zaehler.id} zaehler.werte.class=#{zaehler.werte.class} zaehler.werte.count=#{zaehler.werte.count}")
    zaehler.werte.each do |wert|
      ###wert.x = wert.datum.strftime("%Q")

      diff_tage = wert.datum - letztes_datum
      diff_stand = wert.stand - letzter_stand
      # negative stand Werte nicht anzeigen
      if diff_stand < 0
        diff_stand = 0
      elsif diff_stand == 0

        # zu große Werte nicht anzeigen, da hier etwas nicht stimmen kann
      elsif (diff_stand * 10) > letzter_diff_stand
        ld("diff_stand=#{diff_stand} letzter_diff_stand=#{letzter_diff_stand}")
        #diff_stand = 0
      end

      if diff_tage > 0
        ###wert.y = ("%.1f"%((diff_stand / diff_tage)*30)).to_f
      else
        ###wert.y = 0
      end
      d_naechster = wert.datum.next_month.at_beginning_of_month
      check_wert(i,zaehler,wert.stand,wert.datum,d_letzter_naechster)
      d_letzter_naechster = d_naechster
      letztes_datum = wert.datum
      letzter_stand = wert.stand
      letzter_diff_stand = diff_stand
    end
  end

  def check_wert(i,zaehler,s,d,d_letzter_naechster)
    i+= 1
    d_erster = d.at_beginning_of_month
    d_naechster = d.next_month.at_beginning_of_month
    ##log("debug","Zaehler Id:#{zaehler.id} i=#{i} s=#{s} d=#{d} d_letzter_naechster=#{d_letzter_naechster} d_erster=#{d_erster} d_naechster=#{d_naechster}")
    if ((d_letzter_naechster != d_erster) && (i < 7))
      then
      #w = Wert.new
      #w.stand = s
      #w.datum = d
      # zaehler.werte << w
      ##log("debug","+++Zaehler Id:#{zaehler.id} i=#{i} s=#{s} d=#{d} d_letzter_naechster=#{d_letzter_naechster} d_erster=#{d_erster} d_naechster=#{d_naechster}")
      check_wert(i,zaehler,s,d.prev_month.at_beginning_of_month,d_letzter_naechster)
    end
  end
end
