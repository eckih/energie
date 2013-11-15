$(document).ready(function() {
	
// Format für alle Datumsfelder
$.datepicker.setDefaults({
	dateFormat: "yy-mm-dd",
	altFormat: "yy-mm-dd",
	showOn: "both",
	buttonImage: "/assets/calendar.gif",
	buttonImageOnly: true});

// Wenn sich das Datumsfeld ändert, sollen alle Datumsfelder voreingestellt werden
$( "#tagderAblesung" ).datepicker({
	dateFormat: "yy-mm-dd",
	altFormat: "yy-mm-dd",
	altField: '.wdatum',
	onSelect: function(){
		$( ".wdatum" ).html($("#tagderAblesung").val());
		//$( ".wdatum" ).datepicker( "setDate", "+7d" );
	},
	// sowohl beim klicken auf das Datum als aufs Icon
	showOn: "both",
	buttonImage: "/assets/calendar.gif",
	buttonImageOnly: true
});

// Heutiges Datum ins allgemeine Datumsfeld
$( "#tagderAblesung" ).datepicker("setDate", new Date);

// Alle Datumsfelder voreinstellen
$( ".wdatum" ).val($("#tagderAblesung").val());



/*
$('.best_in_place').bind("ajax:success", function(){ 
	alert('Name updated for '+$(this).data('stand'));
 });
*/
});
