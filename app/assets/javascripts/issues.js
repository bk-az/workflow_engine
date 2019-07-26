$( document ).ready(function() {
  $('#issues_filter_form').on("change", function() {
    $('#issue_filter_submit').click();
  });
  $('#issues_table').DataTable({
    "paging": false,
    "info":   false
  });
});