$( document ).ready(function() {
  $('#drop').change(
  function() {
    var project_filter = $('#project_filter option:selected').val();
    var assignee_filter = $('#assignee_filter option:selected').val();
    var state_filter = $('#state_filter option:selected').val();
    var type_filter = $('#type_filter option:selected').val();
    $.ajax({
      url: "/issues/filter",
      data: { 
              project_id: project_filter,
              assignee_id: assignee_filter,
              issue_state_id: state_filter,
              issue_type_id: type_filter
            }});
  }
  );
});
