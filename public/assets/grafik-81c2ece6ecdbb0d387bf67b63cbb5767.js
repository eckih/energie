function log_object(e){var t="";for(var n in e)t+=n+": "+e[n]+"; ";console.log("object="+t)}function button_nostacking(){console.log("click button_nostacking");var e=$("#zaehler_chart").highcharts();delete e.yAxis[0].usePercentage,$(e.series).each(function(t,n){this.visible&&0>$.inArray(n.name,visibleSeriesIndex)&&(console.log("button_stacking(): serie.name="+n.name+"serie.index="+n.index),e.series[n.index].update({stacking:0},!0))})}function button_percent(){console.log("click button_percent");var e=$("#zaehler_chart").highcharts();delete e.yAxis[0].usePercentage,$(e.series).each(function(e,t){this.visible&&0>$.inArray(t.name,visibleSeriesIndex)&&this.update({stacking:"percent"},!1)}),e.redraw()}function button_verbrauch(){var e=$("#zaehler_chart").highcharts();$(e.series).each(function(t,n){if(this.visible&&"column"!=this.type&&0>$.inArray(n.name,visibleSeriesIndex)){visibleSeriesIndex.push(n.name),console.log("berechne: "+n.name);var r=new Array,i=this.data[0].y,a=0;$(this.data).each(function(e,t){a=Math.round(10*(t.y-i))/10,i=t.y,r.push([t.x,a])}),e.addSeries({name:"Verbrauch "+n.name,data:r,yAxis:1,type:"column",stack:1,stacking:"normal"})}})}var visibleSeriesIndex=new Array;$(document).ready(function(){var e={chart:{zoomType:"xy",renderTo:"zaehler_chart"},title:{text:"Zählerwerte"},xAxis:{type:"datetime"},yAxis:[{title:{text:"Zählerstand in Kilowattstunden [KWh]"}},{title:{text:"Verbrauch pro Monat in Kilowattstunden [KWh]"},opposite:!0}],tooltip:{pointFormat:'<span style="color:{series.color}">{series.name}</span>: <b>{point.y} kWh</b> ({point.percentage:.0f}%)<br/>'},series:[]};$.getJSON("zaehlers/normiertewerte",function(t){e.series=t;var n=new Highcharts.Chart(e);n.series[0],$(n.series).each(function(){this.setVisible(!1,!1)})})});