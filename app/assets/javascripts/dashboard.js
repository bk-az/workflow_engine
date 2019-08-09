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