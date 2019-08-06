$(document).ready(function(){
  issuesReportTable = $('#issues_report_datatable').DataTable({
    dom: 'lBfrtip',
    buttons: [
    'copy', 'csv', 'excel', 'pdf', 'print'
    ]
  } );

  $('div.dataTables_length label').addClass('mb-4')
  var datatable_buttons = $('div.dt-buttons button');
  var datatable_button_classes = ['primary', 'warning', 'success', 'danger', 'info']
  var i;
  for (var i = 0; i < datatable_buttons.length; i++) {
    datatable_buttons.eq(i).removeClass('dt-button');
    datatable_buttons.eq(i).addClass('mx-1 btn btn-' + datatable_button_classes[i]);
  }
});