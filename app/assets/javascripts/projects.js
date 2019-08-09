$( document ).ready(function() {
  // Menu Toggle Script 
  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });
  
  $('#projects_table').DataTable();
});
