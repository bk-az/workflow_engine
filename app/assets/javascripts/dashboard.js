$(document).ready(function(){
  dashboardTable = $('#project_issues');
  projectIssuesTable = $('#project_issues_table').DataTable({
    info: false,
    paging: false,
    scrollY:  "260px",
    scrollCollapse: true,
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });
  // dashboardTable.find('th:eq(0)').click();
  $('.list-group a:eq(0)').addClass('active');
  var assignedIssuesTable = $('#assigned_issues_table').DataTable({
    scrollY:        '50vh',
    scrollCollapse: true,
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });
  var watchingIssuesTable = $('#watching_issues_table').DataTable({
    scrollY:        '50vh',
    scrollCollapse: true,
    oLanguage: {
        sEmptyTable: "No issue found"
    }
  });

  $('a[data-toggle="pill"]').on('shown.bs.tab', function (e) {
    alert('hlloe');
    $('.dataTable').columns.adjust();
  });

});