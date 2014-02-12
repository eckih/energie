$(document).ready(function() {
  $('#Test').click(function(){ 
  console.log("zaehlers.js"); 
    });

  Highcharts.setOptions({
    lang: {
      decimalPoint: ',',
      thousandsSep: '.',
      numericSymbols: null,
    }
  });
  
  chart = new Highcharts.Chart({
    chart: { 
      zoomType: 'xy',
      renderTo: 'stromwerte_chart'
      /* , 
         events: {
          load: function(event) {
            // noch umständlich, erst alle series verstecken
           this.series.forEach(function(d,i){if( d.options.id<100 )d.hide()})
          }
        } */
     },
    title: { text: 'Zählerwerte' },
    xAxis: { type: 'datetime' },
    yAxis: [
    { 
        // yAxis 0
      title: { text: 'Zählerstand in Kilowattstunden [KWh]' }
    },{ // yAxis 1
      title: { text: 'Verbrauch pro Monat in Kilowattstunden [KWh]' },
      opposite: true
    },{ // yAxis 2
      title: { text: 'Kosten pro Monat in Euro' },
      opposite: true
    }
    ],
    tooltip: {
      formatter: function () { 
                   var x = 'KWh';
        //if(this.series.name == 'Kosten') { x = '€ '};
        //if(this.series.name == 'Verbrauch') { x = 'KWh'};
        if(this.series.name.match(/Kosten/)) { x = '€ '};
        if(this.series.name.match(/Verbrauch/)) { x = 'KWh'};
        return '<b>' + this.series.name + '</b>: ' + Highcharts.numberFormat(this.y, 1) + ' ' + x +
        
         ' am ' + Highcharts.dateFormat("%d.%m.%Y", this.x)
        
        ;
      }
    },
    legend: {
      layout: 'vertical',
      align: 'left',
      x: 120,
      verticalAlign: 'top',
      y: 20,
      floating: true,
      backgroundColor: '#FFFFFF'
            }
  });
  
    // activate the button
  $('.button').click(function() {
      // zweidimensionales Daten Array für series
      var data_array = new Array();
      var verbrauch_array = new Array();
      var kosten_array = new Array();
      // element des Arrays besteht aus Datum in millisec seit January 1, 1970 und dem Zählerstand
      var element = new Array();
      var verbrauch_element = new Array();
      var kosten_element = new Array();
      var d,od,dd = new Date();

      // id des Buttons bzw. zaehler_id
      var id = $(this).attr('id');
      
      var kurzbezeichnung = $(this).attr('kurzbezeichnung');
      // alter Stand um Differenz zu ermitteln
      var old_stand = 0;
      var oe = 0;
      var strompreis = 0.26;
      //$(this).attr('disabled', true);
      
//	$(this).hide();
	    
      var Faktor; 
      
      // Werte und Faktor per Ajax vom zaehler_controller (show) holen
      $.getJSON( "/zaehlers/"+id , function(jsondata) {
        Faktor = jsondata.zaehler.faktor;
        // console.log("jsondata.zaehler="+jsondata.zaehler);
        // console.log("jsondata.zaehler.faktor="+jsondata.zaehler.faktor);
        $.each(jsondata.werte, function (i, fb) {
          // Aussortieren der Werte des Zählers dessen Button gedrückt wurde
          if(fb.zaehler_id == id){
            // Datum in millisec umwandeln
            d = new Date(fb.datum);
            anzahlTageimMonat = (new Date(d.getYear(),d.getMonth()+1,0)).getDate();
            dd = d - od ;
            
            // in Tagen
            dd = dd/86400000;
            
            // und in element[0]
            element.push(d.getTime());
            verbrauch_element.push(d.getTime());
            kosten_element.push(d.getTime());
            
            // Zählerstand in element[1]
            element.push(fb.stand);
            verbrauch_element.push((fb.stand-old_stand)/dd*anzahlTageimMonat);
            kosten_element.push((fb.stand-old_stand)/dd*anzahlTageimMonat*strompreis*Faktor);
            
            // element in Array
            data_array.push(element);
            verbrauch_array.push(verbrauch_element);
            kosten_array.push(kosten_element);

            // console.log('fb.datum='+fb.datum+' '+anzahlTageimMonat+' dd='+dd);
            // console.log('verbrauch_element='+verbrauch_element+' element='+element+' fb.stand-old_stand='+(fb.stand-old_stand));
            // console.log(' Standdiff='+((fb.stand-old_stand)-verbrauch_element[1]));
          
            // console.log('kosten_element='+kosten_element+' element='+element+' fb.stand-old_stand='+(fb.stand-old_stand));
            
            // alter stand = neuer stand
            old_stand = fb.stand;
            // old date od = date d
            od = d;
            // element löschen
            element = [];
            // verbrauch_element löschen
            verbrauch_element = [];
            // kosten_element löschen
            kosten_element = [];
            //console.log('____________________');
          }
          // console.log("kosten_array="+kosten_array);
        });

          delete verbrauch_array[0];
          delete kosten_array[0];

     // series anzeigen
      chart.addSeries({
        name: kurzbezeichnung,
        type: 'spline',
        data: data_array.sort()
      });
       chart.addSeries({
         name: 'Verbrauch ' + kurzbezeichnung,
         //name: 'Verbrauch',
         type: 'column',
         yAxis: 1,
         data: verbrauch_array.sort()
       });
      chart.addSeries({
        name: 'Kosten ' + kurzbezeichnung,
        // name: 'Kosten',
        type: 'column',
        yAxis: 2,
        data: kosten_array.sort()
      });
      
    });
    
     });
    
})
