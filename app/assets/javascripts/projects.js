$( document ).ready(function() {
  $('#projects_table').DataTable({
    oLanguage: {
        sEmptyTable: "No Project found"
    }
  });

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
