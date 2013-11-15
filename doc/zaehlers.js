$(document).ready(function() {
  
  $.getJSON( "http://localhost:3006/zaehlers/jsontest" , function(data) {
  	$.each(data, function (i, fb) {
        console.log(fb.stand);
    });
	
  	new Highcharts.Chart({  
     chart: {  
       renderTo: 'container'  
     },          
     series: [{  
       type: 'line',   
       name: 'MSFT',  
       data: [
       [1183939200000,40.71],
		[1184025600000,40.38],
		[1184112000000,40.82]
		]  
     }]  
   }); 
   
  }); 
});