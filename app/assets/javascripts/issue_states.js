$(document).on('turbolinks:load', function(){
  issueStatesTable = $('#issue_states_datatable').DataTable({
    "info": false
  });
  issueStatesTableBody = $('#issue_states_datatable tbody');
  issueStateForm = $("#issue_state_form");
  issueNameSearch = $('#issue_name_search');
  issueStateFlash = $('#issue_state_flash');
  issueStatesErrors = $('#issue_state_errors');
  showIssueStateModal = $('#show_issue_state_modal');
  issueStateCategory = $('#issue_state_category');
  issueStateIssueId = $('#issue_state_issue_id');
  issueIssueStateCategory = $('#issue_issue_state_category');

  var issueStateModal = $('#issue_state_modal');
  var issueStatesCategoryFilter = $('#issue_states_category_filter');
  var issueStatesIssueId = $('#issue_states_issue_id');

  // save these initial attrs to reset form later
  var issueStateFormMethod = issueStateForm.attr("method");
  var issueStateFormAction = issueStateForm.attr("action");

  issueStateModal.on('hidden.bs.modal', function () {
    clearIssueStateForm();
    hideIssueSearch();
    clearFlashMessages();
    resetAttrIssueStateForm();
  });

  issueStateForm.submit(function(e){
    if (issueStateCategory.val() == 'issue' && issueStateIssueId.val() == ''){
      alert('Please Select an Issue');
      return false;
    }
  });

  issueStateCategory.change(function() {
    if ($(this).val() == 'global') {
      hideIssueSearch();
      issueStateIssueId.val('');
      $('#issue_state_issue_name').val('');
    } else if ($(this).val() == 'issue') {
      showIssueSearch();
    }
  }); 

  issueStatesCategoryFilter.change(function() {
    tr = issueStatesTableBody.find('tr');
    tr.show();
    if ($(this).val() == 'global') {
      tr.not(".global").hide();
    } else if ($(this).val() == 'issue') {
      tr.filter(".global").hide();
    }
  });

  $('#issue_states_issue_name_apply').click(function(){
    var id = issueStatesIssueId.val();
    if (id == ''){
      alert('Please select a issue');
      return false
    }
    issueStatesCategoryFilter.val('issue');
    tr = issueStatesTableBody.find('tr');
    tr.hide();
    tr.filter('.issue-' + id).show();
    return false
  });


  function clearFlashMessages() {
    issueStateFlash.html('');
    issueStatesErrors.html('');
  }

  function hideIssueSearch() {
    issueNameSearch.attr("hidden",true);
  }

  function resetAttrIssueStateForm(){
    issueStateForm.attr("method", issueStateFormMethod);
    issueStateForm.attr("action", issueStateFormAction);
  }

});

function resetIssueIssueStateCategory(){
  issueIssueStateCategory.find('label:eq(1)').removeClass('active');
  issueIssueStateCategory.find('label:eq(0)').addClass('active');
}

function showIssueSearch() {
  issueNameSearch.attr("hidden",false);  
}

function clearIssueStateForm() {
  issueStateForm.trigger("reset");
  resetIssueIssueStateCategory();
}
