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
  
  $('#projects_issues_table').DataTable();
});
