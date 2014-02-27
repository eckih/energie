# encoding: UTF-8
class ZaehlersController < ApplicationController
  # GET /zaehlers
  # GET /zaehlers.json
  def index
    @zaehlers = Zaehler.all
    # @zaehlers = Zaehler.includes(:werte).limit( 7)
    # @zaehlers = Zaehler.limit(40)
    verbrauch_berechnen(@zaehlers)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zaehlers} 
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
      # format.json { render :json => { :zaehler => @zaehler, :werte => @werte} }
      # format.json { render json: '{ "name": "John" }' }
      format.json { render json:  @zaehler } # liefert wg. serializer auch Werte
    end
  end

  # JSON Antwort auf get Request in verbrauch.js
  def show_more
    @zaehler = Zaehler.find(params[:ids])
    render json: @zaehler  # liefert wg. serializer auch Werte
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

  def getverbrauch

    # json Array wird an Client auf getJSON-Anfrage per ajax Request gesendet
    json_array = Array.new

    zaehlerids = Zaehler.find(params[:ids])
    #zaehlerids = Zaehler.select(:id).limit(12)
    log("debug","zaehlerids=#{zaehlerids.to_json}")
    testid = Array.new(10)
    zaehlerids.each {|id|
      json_array = verbrauch(id)
    }

    ##
    # @zaehler = Zaehler.find(:all, :select => 'id, kurzbezeichnung')
    # zaehlerids.each {|id|
    #   @werte = Wert.find(:all, :select => 'zaehler_id, stand,datum', :conditions => {:zaehler_id => id}, :order => :datum )
    #   log("debug","@werte=#{@werte.to_json}")

    # render json: [ @werte,  @zaehler ]
    render json: json_array.to_json
  end  

  private

  def verbrauch(id)
    # stand_array = Array.new
    verbrauch_array = Array.new
    # Datenbankabfrage der Werte eines Zählers
    werte = Wert.where(zaehler_id: id).order(:datum)
    # letzter Stand für die Berechnung des Verbrauchs; Erster Wert muss 0 werden
    letzter_stand = werte[0].stand
    letztes_datum = werte[0].datum
    werte.each {|wert|
      diff_stand = (wert.stand-letzter_stand).to_f
      diff_datum = (wert.datum-letztes_datum).to_i
      if diff_datum == 0 
        diff_datum = 31
      end
      # stand muss berichtigt werden, da nicht immer genau 31 Tage zwischen den abgelesenen Werten liegen
      # erst Anzahl der Tage des letzten Monats ermitteln
      anzahltage=(wert.datum.to_date.end_of_month-wert.datum.to_date.beginning_of_month).to_i+1
      diff_stand_berichtigt = ((diff_stand.to_f/diff_datum.to_f)*anzahltage)

      # Monate ohne Messung interpolieren und einfügen, damit Gesamtwert stimmt
      # log("debug","diff_datum / 30=#{diff_datum/30} diff_datum % 30 = #{diff_datum%30}")
      monate_einfügen = (diff_datum/30)-1
      monate_einfügen.times do |i| log("debug","letztes_datum=#{letztes_datum} #{monate_einfügen-i} #{(wert.datum - ((monate_einfügen-i)*30).days)}  EINFÜGEN diff_stand_berichtigt=#{diff_stand_berichtigt}") end if ((monate_einfügen > 0) and (letztes_datum.to_s != "2010-12-31"))
      # monate_einfügen.times do |i| verbrauch_array << [ (wert.datum - ((monate_einfügen-i)*30).days).strftime('%Q').to_i, diff_stand_berichtigt ] end if monate_einfügen > 1
      # Die ersten Monate sollen nicht interpoliert werden, da da der Zähler evtl. noch nicht vorhanden war(letztes_datum != "2010-12-31".to_s)
      # 
      monate_einfügen.times do |i| verbrauch_array << [ (wert.datum - ((monate_einfügen-i)*30).days + 15.days).at_beginning_of_month.strftime('%Q').to_i, diff_stand_berichtigt ] end if ((monate_einfügen > 0) and (letztes_datum.to_s != "2010-12-31"))

      # verbrauch_array << [wert.datum.strftime('%Q').to_i, diff_stand_berichtigt ]
      verbrauch_array << [(wert.datum + 15.days).at_beginning_of_month.strftime('%Q').to_i, diff_stand_berichtigt ]
      # log("debug","zaehler_id=#{id} letztes_datum=#{letztes_datum} wert.datum=#{wert.datum} diff_datum=#{diff_datum} anzahltage=#{anzahltage} diff_stand=#{diff_stand} diff_stand_berichtigt=#{diff_stand_berichtigt} berichtigt=#{diff_stand-diff_stand_berichtigt} wert.stand=#{wert.stand}")
      letzter_stand = wert.stand
      letztes_datum = wert.datum
    }
    verbrauch_array 
  end

  private

  def verbrauch_berechnen(zaehlers)
    i = 0
    d_letzter_naechster = 0
    zaehlers.each do |zaehler|
      letzter_diff_stand = 0
      letzter_stand = zaehler.werte[0].stand
      letztes_datum = zaehler.werte[0].datum
      ld("Id=#{zaehler.id} zaehler.werte.class=#{zaehler.werte.class} zaehler.werte.count=#{zaehler.werte.count}")
      zaehler.werte.each do |wert|
        wert.x = wert.datum.strftime("%Q")

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
          wert.y = ("%.1f"%((diff_stand / diff_tage)*30)).to_f
        else
          wert.y = 0
        end
        d_naechster = wert.datum.next_month.at_beginning_of_month
        check_wert(i,zaehler,wert.stand,wert.datum,d_letzter_naechster)
        d_letzter_naechster = d_naechster
        letztes_datum = wert.datum
        letzter_stand = wert.stand
        letzter_diff_stand = diff_stand
      end
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

  def _verbrauch_berechnen(zaehlers)
    # über alle Zähler iterieren
    zaehlers.each do |zaehler|
      # letzten Stand als float initialisieren
      letzter_stand = 0.0
      letztes_msec_datum = Date.new(0).strftime('%Q').to_i
      letztes_datum = Date.new(0).strftime('%Q').to_i

      alt_msec_naechster_erster = 0
      # über alle Werte eines Zählers iterieren ...
      zaehler.werte.each do |wert|
        wert_datum = wert.datum

        # Verbrauch aus Differenz zum letzten Wert berechnen und in virtu/elles Attribut eintragen 
        wert.verbrauch = "%.1f"%(wert.stand - letzter_stand).to_f if letzter_stand != 0.0

        stand_letzter_erster, msec_letzter_erster, msec_naechster_erster, verbrauch_aktueller_monat = letzter_erster(wert.stand,wert_datum,letzter_stand,letztes_msec_datum, letztes_datum) 
        ##log("debug","wert.datum=#{wert.datum} msec_letzter_erster=#{msec_letzter_erster} msec_naechster_erster=#{msec_naechster_erster} verbrauch_aktueller_monat=#{verbrauch_aktueller_monat} msec-diff=#{msec_naechster_erster-msec_letzter_erster}")
        letztes_datum = wert_datum
        wert.datum = msec_letzter_erster
        wert.x = Date.new(0).strftime('%Q').to_i
        wert.verbrauch = verbrauch_aktueller_monat

        # Datum in msec für highchart x-Axis umrechnen
        # wert.datum = wert.datum.strftime('%Q').to_i

        # letzten Stand und msec_datum auf aktuellen Wert sezen 
        letzter_stand = wert.stand

        alt_msec_naechster_erster = msec_naechster_erster
        ## log("debug","wert.stand=#{wert.stand} wert.verbrauch=#{wert.verbrauch} letzter_stand=#{letzter_stand}")
      end
    end
  end

  def letzter_erster(stand, datum,letzter_stand,letztes_msec_datum, letztes_datum) 
    # Umrechnung des Datums in msec für highchart
    msec_datum = datum.to_i
    norm_datum = Time.at(datum.to_i/1000)
    #letztes_msec_datum = letztes_datum.strftime('%Q').to_i
    # Differenz msec des aktuellen Werts zum letzten Wert
    diff_msec = msec_datum.to_i - letztes_msec_datum.to_i
    diff_tage = datum.to_i - letztes_datum.to_i
    # erster des nächsten Monats wert.datum in msec
    msec_naechster_erster = norm_datum.next_month.at_beginning_of_month.strftime('%Q').to_i
    naechster_erster = norm_datum.next_month.at_beginning_of_month
    # erster des Monats wert.datum in msec
    msec_letzter_erster = norm_datum.at_beginning_of_month.strftime('%Q').to_i
    letzter_erster = norm_datum.at_beginning_of_month
    # Anzahl msec im aktuellen Monat
    msec_aktueller_monat = msec_naechster_erster - msec_letzter_erster
    aktueller_monat = naechster_erster - letzter_erster
    # Differenz vom Wert zum letzten Ersten des Monats
    diff_msec_zum_letzten_ersten = msec_datum - msec_letzter_erster
    diff_tage_zum_letzten_ersten = norm_datum - letzter_erster
    # Differenz stand zum letzten Wert gerundet
    diff_stand = (stand - letzter_stand).to_f
    # Differenz stand pro msec 
    diff_stand_pro_msec = diff_stand / diff_msec
    diff_stand_pro_tag = diff_stand / diff_tage
    # Differenz stand zum letzten Ersten des Monats
    ##diff_stand_zum_letzten_ersten = diff_stand_pro_msec * diff_msec_zum_letzten_ersten
    diff_stand_zum_letzten_ersten = diff_stand_pro_tag * diff_tage_zum_letzten_ersten
    # Stand am letzten Ersten des Monats
    stand_letzter_erster = "%.1f"%(stand - diff_stand_zum_letzten_ersten)
    # Verbrauch im aktuellen Monat
    verbrauch_aktueller_monat = "%.1f"%(msec_aktueller_monat * diff_stand_pro_msec)
    verbrauch_aktueller_monat = "%.1f"%(aktueller_monat * diff_stand_pro_tag)

    ## log("debug","datum=#{datum} letztes_msec_datum=#{letztes_msec_datum} msec_letzter_erster= #{msec_letzter_erster} msec_naechster_erster=#{msec_naechster_erster} diff_msec_zum_letzten_ersten=#{diff_msec_zum_letzten_ersten} diff_stand_pro_msec=#{diff_stand_pro_msec} msec-diff=#{msec_naechster_erster-msec_letzter_erster}" )
    log("debug","datum=#{datum} letztes_datum=#{letztes_datum} letzter_erster= #{letzter_erster} naechster_erster=#{naechster_erster} diff_tage_zum_letzten_ersten=#{diff_tage_zum_letzten_ersten} diff_stand_pro_tag=#{diff_stand_pro_tag} diff=#{naechster_erster-letzter_erster}" )
    log("debug","datum=#{datum} stand=#{stand} letzter_stand=#{letzter_stand} diff_stand= #{'%.1f'%diff_stand} diff_stand_zum_letzten_ersten =#{'%.1f'%diff_stand_zum_letzten_ersten } stand_letzter_erster=#{stand_letzter_erster} verbrauch_aktueller_monat=#{verbrauch_aktueller_monat} " )
    if Time.at(letztes_datum.to_i/1000).next_month.at_beginning_of_month != letzter_erster
      then
      log("debug","--- datum=#{datum} norm_datum.at_beginning_of_month=#{norm_datum.at_beginning_of_month} datum.next_month.at_beginning_of_month=#{norm_datum.next_month.at_beginning_of_month} Time.at(letztes_datum/1000).next_month.at_beginning_of_month=#{Time.at(letztes_datum.to_i/1000).next_month.at_beginning_of_month}")
      ### Rekursiv !!!
      # letzter_erster(stand, datum.at_beginning_of_month,letzter_stand,letztes_msec_datum, letztes_datum) 
    end
    return stand_letzter_erster, msec_letzter_erster, msec_naechster_erster, verbrauch_aktueller_monat 
  end

end
