$(document).ready(function(){
  issueStatesTable = $('#issue_states_datatable').DataTable({
    "info": false
  });

  issueStateIssuesModal = $('#issue_state_issues_modal');
  issueStateModal = $('#issue_state_modal');
  issueStatesTableBody = $('#issue_states_datatable tbody');
  issueStateFlash = $('#issue_state_flash');
  issueStatesErrors = $('#issue_state_errors');
  
  issueStateModal.on('hidden.bs.modal', function () {
    clearFlashMessages();
    $('#issue_state_form_area').html('');
  });

  issueStateIssuesModal.on('shown.bs.modal', function(){
    issueStateIssuesTable.columns.adjust();
  });

  function clearFlashMessages() {
    issueStateFlash.html('');
    issueStatesErrors.html('');
  }

});