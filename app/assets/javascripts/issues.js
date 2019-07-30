$( document ).ready(function() {
  $('#issues_filter_form').on("change", function() {
    $('#issue_filter_submit').click();
  });
  
  $('#issues_table').DataTable({
    "paging": false,
    "info":   false
  });

  $('#add_watchers_modal').on('hidden.bs.modal', function (e) {
    $('#add_modal_search_results').html('');
    $('.watcher_search').val('');
  })

  $('#remove_watchers_modal').on('hidden.bs.modal', function (e) {
    $('#remove_modal_search_results').html('');
    $('.watcher_search').val('');
  })
});