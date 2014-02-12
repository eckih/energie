$(document).ready(function(){zaehler_chart=new Highcharts.Chart({chart:{zoomType:"xy",renderTo:"zaehler_chart"},title:{text:"Zählerwerte"},xAxis:{type:"datetime"},yAxis:[{title:{text:"Zählerstand in Kilowattstunden [KWh]"}},{title:{text:"Verbrauch pro Monat in Kilowattstunden [KWh]"},opposite:!0},{title:{text:"Kosten pro Monat in Euro"},opposite:!0}],tooltip:{formatter:function(){var t="KWh";return this.series.name.match(/Kosten/)&&(t="€ "),this.series.name.match(/Verbrauch/)&&(t="KWh"),"<b>"+this.series.name+"</b>: "+Highcharts.numberFormat(this.y,1)+" "+t+" am "+Highcharts.dateFormat("%d.%m.%Y",this.x)}},legend:{layout:"vertical",align:"left",x:120,verticalAlign:"top",y:20,floating:!0,backgroundColor:"#FFFFFF"}}),Highcharts.setOptions({lang:{decimalPoint:",",thousandsSep:".",numericSymbols:null}}),$.getJSON("zaehlers",function(t){$.each(t.zaehlers,function(t,e){console.log("i="+t+" zaehler="+e),zaehler_chart.addSeries({id:e.id,name:e.kurzbezeichnung,type:"column",data:e.werte.stand})})}),chart=new Highcharts.Chart({chart:{zoomType:"xy",renderTo:"stromwerte_chart"},title:{text:"Zählerwerte"},xAxis:{type:"datetime"},yAxis:[{title:{text:"Zählerstand in Kilowattstunden [KWh]"}},{title:{text:"Verbrauch pro Monat in Kilowattstunden [KWh]"},opposite:!0},{title:{text:"Kosten pro Monat in Euro"},opposite:!0}],tooltip:{formatter:function(){var t="KWh";return this.series.name.match(/Kosten/)&&(t="€ "),this.series.name.match(/Verbrauch/)&&(t="KWh"),"<b>"+this.series.name+"</b>: "+Highcharts.numberFormat(this.y,1)+" "+t+" am "+Highcharts.dateFormat("%d.%m.%Y",this.x)}},legend:{layout:"vertical",align:"left",x:120,verticalAlign:"top",y:20,floating:!0,backgroundColor:"#FFFFFF"}}),$(".button").click(function(){var t,e,i,n=new Array,r=new Array,o=new Array,s=new Array,a=new Array,l=new Array,h=new Date,c=$(this).attr("id"),u=$(this).attr("kurzbezeichnung"),d=0,p=.26;$.getJSON("/zaehlers/"+c,function(f){i=f.zaehler.faktor,$.each(f.werte,function(u,f){f.zaehler_id==c&&(t=new Date(f.datum),anzahlTageimMonat=new Date(t.getYear(),t.getMonth()+1,0).getDate(),h=t-e,h/=864e5,s.push(t.getTime()),a.push(t.getTime()),l.push(t.getTime()),s.push(f.stand),a.push((f.stand-d)/h*anzahlTageimMonat),l.push((f.stand-d)/h*anzahlTageimMonat*p*i),n.push(s),r.push(a),o.push(l),d=f.stand,e=t,s=[],a=[],l=[])}),delete r[0],delete o[0],chart.addSeries({name:u,type:"spline",data:n.sort()}),chart.addSeries({name:"Verbrauch "+u,type:"column",yAxis:1,data:r.sort()}),chart.addSeries({name:"Kosten "+u,type:"column",yAxis:2,data:o.sort()})})})});