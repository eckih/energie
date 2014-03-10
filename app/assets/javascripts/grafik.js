function button_debug_info(){
console.log("+++ Begin debug_info()");
  var zaehler_chart = $('#zaehler_chart').highcharts();
    $(zaehler_chart.series).each(function(i, serie){
      if(serie.visible){
      console.log("serie["+i+"] name="+serie.name+" id="+serie.options.id);
      //log_object(serie);
      }
      // console.log("serie["+i+"] name="+serie.name+" id="+serie.options.id);
    });

  var item;
  for(var key in localStorage) {
    item = localStorage.getItem(key);
    if( item == "on" ){
      var serie = zaehler_chart.get(key);
      console.log("LocalStorage key="+key+" item="+item+" serie="+serie);
    }
  }

console.log("+++ End debug_info()");
}

function initlocalStorage(){
  if (Modernizr.localstorage) {
    console.log("window.localStorage is available!");
  } else {
    console.log(" no native support for HTML5 storage :( maybe try dojox.storage or a third-party solution");
  }
}

function button_localStorageClear(){
localStorage.clear();
alert("Lokalen Speicher im Browser für diese Seite gelöscht");
}

function show_storaged_series(){
  var zaehler_chart = $('#zaehler_chart').highcharts();
  
  for(var key in localStorage) {
  var item;
    item = localStorage.getItem(key);
    if( item == "on" ){
      //var keystr = key.substr(1);
      var id = key.substr(1);
      var serie = zaehler_chart.get(id);
      serie.select();
      console.log(item+"  key="+key+" key.substr(1)="+key.substr(1)+" serie="+serie.name);
    }   
//       serie.select();
    }
  //})
button_verbrauch();
}

function log_object(object){
  var output = '';
  for (var property in object) {
    output += property + ': ' + object[property]+'; ';
  }
  console.log("object="+output);
}

/* no stacking */
function button_nostacking(){
  console.log("click button_nostacking");
  var zaehler_chart = $('#zaehler_chart').highcharts();

  delete zaehler_chart.yAxis[0].usePercentage;
  // Linien müssen noch aussortiert werden
  $(zaehler_chart.series).each(function(k,serie){
    if( this.visible && $.inArray(serie.name, visibleSeriesIndex) < 0  ) {
      console.log("button_stacking(): serie.name="+serie.name+ "serie.index="+serie.index);
      zaehler_chart.series[serie.index].update({ stacking: 0 },true); 
    }
  })
  //zaehler_chart.redraw();
}

/* percent */
function button_percent(){
  console.log("click button_percent");
  var zaehler_chart = $('#zaehler_chart').highcharts();
  delete zaehler_chart.yAxis[0].usePercentage;
  $(zaehler_chart.series).each(function(k,serie){
    if( this.visible && $.inArray(serie.name, visibleSeriesIndex) < 0  ) {
      this.update({ stacking: 'percent' },false); 
    }
  })
  zaehler_chart.redraw();
}

function addverbrauch(chart, serie) {
    var data = new Array();
    // initialisiere letztes Werteobject 
    var last_y = serie.data[0].y;
    //var diff = 0;
    $(serie.data).each(function(i, fb){
      var diff = Math.round((fb.y-last_y)*10)/10;
      last_y = fb.y;
      data.push([fb.x,diff]);
      //console.log("i="+i+" fb.x="+fb.x+" fb.y="+fb.y+" diff="+diff+" last_y="+last_y);
    });
      chart.addSeries({ 
        id: "V"+serie.options.id,
        name: "Verbrauch "+serie.name,
        data: data,
        yAxis: 1,
        type: 'column',
        stack: 1,
        stacking: 'normal',
        pointRange: serie.pointRange
      },false);
      console.log("addverbrauch() serie.options.id="+serie.options.id);
      localStorage.setItem("V"+serie.options.id, "on");
      console.log('localStorage.setItem(V'+serie.options.id+', "on")');
    //log_object(serie);
   button_debug_info(); 
}

/* Verbrauch */
function button_verbrauch(){

  var zaehler_chart = $('#zaehler_chart').highcharts();

  $(zaehler_chart.series).each(function(k,serie){
      // log_object(this);
    if(serie.visible && serie.options.id.match(/V/)) {
      console.log("remove serie.options.id="+serie.options.id);
      localStorage.setItem(serie.options.id, "off");
      serie.remove();
    };
  })
  selectedSeries = zaehler_chart.getSelectedSeries(); // http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/members/chart-getselectedseries/

  selectedSeries.map(function(serie){
    console.log("button_verbrauch(): selectedSeries serie.name="+serie.name);
    if(localStorage.getItem("V"+serie.options.id) != "on"){
    } // end if
      addverbrauch(zaehler_chart, serie);

  })
  zaehler_chart.redraw();
}


/*
   function _button_verbrauch(){
   var zaehler_chart = $('#zaehler_chart').highcharts();

// über alle Series iterieren
$(zaehler_chart.series).each(function(k,serie){
// Wenn Serie sichtbar und nicht schon Balkengrafik (also Zählerwerte) und nicht in visibleSeriesIndex (also schon einmal Verbrauch berechnet)
if( this.visible && this.type != 'column' && $.inArray(serie.name, visibleSeriesIndex) < 0 ) {

// im visibleSeriesIndex merken, damit Verbrauch nicht nochmal berechnet wird
visibleSeriesIndex.push(serie.name);
//console.log("berechne: "+serie.name);

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
stack: 1,
stacking: 'normal',
pointRange: serie.pointRange
});
}
});
}
*/

var visibleSeriesIndex = new Array; // angezeigten Serien, damit Verbrauch nicht doppelt angezeigt wird
$(document).ready(function() {
//console.log("+++ Begin grafik.js +++");

  initlocalStorage();

  var options = {
    chart: { 
      events: {
        addSeries: function(event) {
          console.log ('series added: event.options.name='+event.options.name+' event.options.id='+event.options.id);
        },
  click: function(event){
    console.log('highcharts click event='+event);
  },
  drilldown: function(event){
    console.log('highcharts drilldown event='+event);
  },
  drillup: function(event){
    console.log('highcharts drillup event='+event);
  },
  load: function(event){
    console.log('highcharts load event='+event);
    show_storaged_series();
  },
  selection: function(event){
    console.log('highcharts selection event='+event);
  },
  redraw: function(event){
    console.log('highcharts redraw event='+event);
  },
  checkboxClick: function(event){
    console.log('highcharts checkboxClick event='+event);
  }
      },
      zoomType: 'xy',
      renderTo: 'zaehler_chart'
    },
    title: { text: 'Zählerwerte' },
    xAxis: { type: 'datetime'},
    yAxis: [
      // yAxis 0
    { title: { text: 'Zählerstand in Kilowattstunden [KWh]' } },
    // yAxis 1
    { title: { text: 'Verbrauch pro Monat in Kilowattstunden [KWh]' },
      opposite: true
    } 
    ],
      tooltip: {
        pointFormat: '{series.options.id}: <span style="color:{series.color}">{series.name}</span>: <b>{point.y} kWh</b> ({point.percentage:.0f}%) Total: {point.stackTotal:.1f} kWh<br/>',
        //formatter: function(){ return this.series.name+' id='+this.series.options.id; }
                   /*
                      formatter: function () { 
                      var x = 'KWh';
                      return '<b>' + this.series.id + ':' + this.series.name + '</b>: ' + Highcharts.numberFormat(this.y, 1) + ' ' + x + ' am ' + Highcharts.dateFormat("%d.%m.%Y", this.x) + " (" + ({this.percentage:.0f}%) + "%)" ;
                      }
                      */
      },
      plotOptions: {
        series: {
          showCheckbox: true,
          pointRange: 2592000000,
          events: {
          checkboxClick: function(event) {
                        //alert ('The checkbox is now '+ event.checked);
                        this.select();
                        button_verbrauch();
                        return false;
                    }
        }
        }
      },
      series:[]
  };
    
  // Alle Zähler auf einmal per Ajax von method index holen
  $.getJSON('zaehlers/normiertewerte', function (json){

    options.series = json;  // Daten setzen
    //options.series[0].id = 'id0';  // Daten setzen

    //log_object(options.series[0]);
    var zaehler_chart = new Highcharts.Chart(options);
    // Alle Serien verstecken
    $(zaehler_chart.series).each(function(){
      if(this.visible && !this.options.id.match(/V/)) {
      this.setVisible(false, false);
      //console.log("id="+this.options.id);
      localStorage.setItem(this.options.id, "off");
      //var series = zaehler_chart.series[0];
      } 
    });
  });



//console.log("+++ End grafik.js +++");
})
