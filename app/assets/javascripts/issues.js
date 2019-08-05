$( document ).ready(function() {
  $('#issues_filter_form').on("change", function() {
    $(this).submit();
  });
  $('#issues_table').DataTable({
    "paging": false,
    "info":   false
  });
});
