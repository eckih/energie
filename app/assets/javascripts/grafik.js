
function log_object(object){
  var output = '';
  for (var property in object) {
    output += property + ': ' + object[property]+'; ';
  }
  console.log("object="+output);
}

/* stacking */
function button_stacking(){
  console.log("click button_stacking");
  var zaehler_chart = $('#zaehler_chart').highcharts();
  /*
     for( var i = 0; i < zaehler_chart.series.length ; i++){
     zaehler_chart.series[i].update({ stacking: 'normal'   }); 
     }
     */

  // Linien müssen noch aussortiert werden
  $(zaehler_chart.series).each(function(k,serie){
    if( this.visible && $.inArray(serie.name, visibleSeriesIndex) < 0  ) {
      this.update({ stacking: 'normal' }); 
    }
  })
}

/* percent */
function button_percent(){
  console.log("click button_percent");
  var zaehler_chart = $('#zaehler_chart').highcharts();
  $(zaehler_chart.series).each(function(k,serie){
    if( this.visible && $.inArray(serie.name, visibleSeriesIndex) < 0  ) {
      this.update({ stacking: 'percent' }); 
    }
  })
}

/* Verbrauch */
function button_addSerie(){
  var zaehler_chart = $('#zaehler_chart').highcharts();

  // über alle Series iterieren
  $(zaehler_chart.series).each(function(k,serie){
    // Wenn Serie sichtbar und nicht schon Balkengrafik (also Zählerwerte) und nicht in visibleSeriesIndex (also schon einmal Verbrauch berechnet)
    if( this.visible && this.type != 'column' && $.inArray(serie.name, visibleSeriesIndex) < 0 ) {

      // im visibleSeriesIndex merken, damit Verbrauch nicht nochmal berechnet wird
      visibleSeriesIndex.push(serie.name);
      console.log("berechne: "+serie.name);

      // data Array für serie
      var data = new Array();

      // initialisiere letztes Werteobject 
      var last_y = this.data[0].y;
      var diff = 0;
      $(this.data).each(function(i, fb){
        diff = Math.round((fb.y-last_y)*10)/10;
        last_y = fb.y;
        data.push([fb.x,diff]);
        //console.log("i="+i+" fb.x="+fb.x+" fb.y="+fb.y+" diff="+diff+" last_y="+last_y);
        // log_object(this);
      });
      zaehler_chart.addSeries({ 
        name: "Verbrauch "+serie.name,
        data: data,
        yAxis: 1,
        type: 'column',
        stack: 1
        //stacking: 'normal'
      });
    }
  });
}

var visibleSeriesIndex = new Array; // angezeigten Serien, damit Verbrauch nicht doppelt angezeigt wird
$(document).ready(function() {

  var options = {
    chart: { 
      zoomType: 'xy',
  renderTo: 'zaehler_chart'
    },
  title: { text: 'Zählerwerte' },
  xAxis: { type: 'datetime' },
  yAxis: [
  // yAxis 0
{ title: { text: 'Zählerstand in Kilowattstunden [KWh]' } },
// yAxis 1
{ title: { text: 'Verbrauch pro Monat in Kilowattstunden [KWh]' },
  opposite: true
} 
],
tooltip: {
  pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y} kWh</b> ({point.percentage:.0f}%)<br/>'
  /*
     formatter: function () { 
     var x = 'KWh';
     return '<b>' + this.series.name + '</b>: ' + Highcharts.numberFormat(this.y, 1) + ' ' + x + ' am ' + Highcharts.dateFormat("%d.%m.%Y", this.x) + " (" + ({this.percentage:.0f}%) + "%)" ;
     }
     */
},
  series: []
  };

// Alle Zähler auf einmal per Ajax von method index holen
$.getJSON('zaehlers/normiertewerte', function (json){
  //$.getJSON('zaehlers', function (json){
  options.series = json;  // Daten setzen
  var zaehler_chart = new Highcharts.Chart(options);
  var series = zaehler_chart.series[0];
  // Alle Serien verstecken
  $(zaehler_chart.series).each(function(){
    this.setVisible(false, false);
  });
});
    })
