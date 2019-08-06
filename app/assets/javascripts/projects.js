//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/


$( document ).ready(function() {
  // Menu Toggle Script 
  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });
  
  // TODO: Needs to be updated later
  $("#myInput").on("keyup", function() {
    var value = $(this).val().toLowerCase();
    $("#myList tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});
