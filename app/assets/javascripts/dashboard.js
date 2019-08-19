$(document).ready(function(){
  projectIssues = $('#project_issues');
  projectIssuesTable = $('#project_issues_table').DataTable({
    info: false,
    paging: false,
    scrollY:  "38vh",
    scrollCollapse: true,
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });

  $('.list-group a:eq(0)').addClass('active');
  var assignedIssuesTable = $('#assigned_issues_table').DataTable({
    info: false,
    paging: false,
    scrollY: '50vh',
    scrollCollapse: true,
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });
  var watchingIssuesTable = $('#watching_issues_table').DataTable({
    info: false,
    paging: false,
    scrollY: '50vh',
    scrollCollapse: true,
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });

  $('a[data-toggle="pill"]').on('shown.bs.tab', function (e) {
    assignedIssuesTable.columns.adjust();
    watchingIssuesTable.columns.adjust();
    projectIssuesTable.columns.adjust();
  });

});