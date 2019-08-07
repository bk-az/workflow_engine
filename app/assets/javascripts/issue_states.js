$(document).ready(function(){
  issueStatesTable = $('#issue_states_datatable').DataTable({
    "info": false
  });

  showIssueStateModal = $('#show_issue_state_modal');
  issueStateModal = $('#issue_state_modal');
  issueStatesTableBody = $('#issue_states_datatable tbody');
  issueStateFlash = $('#issue_state_flash');
  issueStatesErrors = $('#issue_state_errors');
  
  var issueStatesCategoryFilter = $('#issue_states_category_filter');
  var issueStatesIssueId = $('#issue_states_issue_id');

  issueStateModal.on('hidden.bs.modal', function () {
    clearFlashMessages();
    $('#issue_state_form_area').html('');
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
      alert('Please select an issue');
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

  $('#issue_state_form_area').on("change", "select", function(){
    if ($(this).val() == 'global') {
      $('#issue_search_area').attr("hidden", true);
      $('#issue_search_area input').val('');
    } else if ($(this).val() == 'issue_specific') {
      $('#issue_search_area').attr("hidden", false);
    }
  });

  $('#issue_state_form_area').on("submit", "form", function(){
    var category = $('#issue_state_category').val();
    var issue_id = $('#issue_state_issue_id').val();
    if (category == 'issue_specific' && issue_id == ''){
      alert('Please Select an Issue');
      return false;
    }
  });
});

function resetIssueStateCategoryToggle(){
  var categoryToggle = $('#issue_state_category_toggle');
  if (categoryToggle.length > 0) {
    categoryToggle.find('label').removeClass('active');
    categoryToggle.find('label:eq(0)').addClass('active');
  }
}

function issueStateCategoryToggleSetGlobal(){
  var categoryToggle = $('#issue_state_category_toggle');
  if (categoryToggle.length > 0) {
    categoryToggle.find('label').removeClass('active');
    categoryToggle.find('label:eq(1)').addClass('active');
    categoryToggle.find('input[name=category][value=global]').prop('checked', true);
  }
}
