$(document).ready(function(){
  projectIssues = $('#project_issues');

  $('.list-group a:eq(0)').addClass('active');
  $('#assigned_issues_table').DataTable({
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });
  $('#watching_issues_table').DataTable({
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });

});