$(function() {
  $('#issues_filter_form').on("change", function() {
    $(this).submit();
  });

  $('#issues_table').DataTable({
    "paging": false,
    "info":   false
  });

  $('#add_watchers_modal').on('hidden.bs.modal', function (e) {
    $('#add_modal_search_results').html('').removeClass('modal-with-vertical-scroll-content');
    $('.watcher_search').val('');
  })

  $('#remove_watchers_modal').on('hidden.bs.modal', function (e) {
    $('#remove_modal_search_results').html('').removeClass('modal-with-vertical-scroll-content');
    $('.watcher_search').val('');
  })

  $('.radio_button_div').on("change", function() {
    $('#add_modal_search_results').html('');
    $('#remove_modal_search_results').html('');
    $('.watcher_search').val('');
  });

  // datePicker
  $('#issue_start_date').datepicker({
     dateFormat: 'yy-mm-dd'
  });
  $('#issue_due_date').datepicker({
     dateFormat: 'yy-mm-dd'
  });

  issuesModal = $('#issues_modal');
  issuesModal.on('shown.bs.modal', function(){
    issuesTable.columns.adjust();
  });
});
