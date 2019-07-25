$( document ).ready(function() {
  $('#issues_filter_dropdown').on("keyup change", function() {
    var project_filter = $('#project_filter option:selected').val();
    var assignee_filter = $('#assignee_filter option:selected').val();
    var state_filter = $('#state_filter option:selected').val();
    var type_filter = $('#type_filter option:selected').val();
    var search_filter = $('#search_filter').val();
    $.ajax({
      url: "/issues/filter",
      data: { 
              project_id:     project_filter,
              assignee_id:    assignee_filter,
              issue_state_id: state_filter,
              issue_type_id:  type_filter,
              search_filter:  search_filter
            }
    });
  });
  $('#modal_search_watcher').click(function() {
    var watcher_email = $('#modal_watcher_email').val();
    $.ajax({
      url: "/issues/search_watcher",
      data: { watcher_email: watcher_email }
    });
  });
});
  
  

