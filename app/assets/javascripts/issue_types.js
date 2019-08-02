$(document).on('turbolinks:load', function(){
  table = $('#issue_types_datatable').DataTable({
    "info": false
  });
  tableBody = $('#issue_types_datatable tbody');
  issueTypeForm = $("#issue_type_form");
  projectNameSearch = $('#project_name_search');
  issueTypeFlash = $('#issue_type_flash');
  issueTypesErrors = $('#issue_type_errors');
  showIssueTypeModal = $('#show_issue_type_modal');
  issueTypeCategory = $('#issue_type_category');
  issueTypeProjectId = $('#issue_type_project_id');

  var issueTypeModal = $('#issue_type_modal');
  var issueTypesCategoryFilter = $('#issue_types_category_filter');
  var issueTypesProjectId = $('#issue_types_project_id');

  // save these initial attrs to reset form later
  var issueTypeFormMethod = issueTypeForm.attr("method");
  var issueTypeFormAction = issueTypeForm.attr("action");

  issueTypeModal.on('hidden.bs.modal', function () {
    clearIssueTypeForm();
    hideProjectSearch();
    clearFlashMessages();
    resetAttrIssueTypeForm();
  });

  issueTypeForm.submit(function(e){
    if (issueTypeCategory.val() == 'project' && issueTypeProjectId.val() == ''){
      alert('Please Select a Project');
      return false;
    }
  });

  issueTypeCategory.change(function() {
    if ($(this).val() == 'global') {
      hideProjectSearch();
      issueTypeProjectId.val('');
      $('#issue_type_project_name').val('');
    } else if ($(this).val() == 'project') {
      showProjectSearch();
    }
  }); 

  issueTypesCategoryFilter.change(function() {
    tr = tableBody.find('tr');
    tr.show();
    if ($(this).val() == 'global') {
      tr.not(".global").hide();
    } else if ($(this).val() == 'project') {
      tr.filter(".global").hide();
    }
  });

  $('#issue_types_project_name_apply').click(function(){
    var id = issueTypesProjectId.val();
    if (id == ''){
      alert('Please select a project');
      return false
    }
    issueTypesCategoryFilter.val('project');
    tr = tableBody.find('tr');
    tr.hide();
    tr.filter('.project-' + id).show();
    return false
  });


  function clearFlashMessages() {
    issueTypeFlash.html('');
    issueTypesErrors.html('');
  }

  function hideProjectSearch() {
    projectNameSearch.attr("hidden",true);
  }

  function resetAttrIssueTypeForm(){
    issueTypeForm.attr("method", issueTypeFormMethod);
    issueTypeForm.attr("action", issueTypeFormAction);
  }

});

function showProjectSearch() {
  projectNameSearch.attr("hidden",false);  
}

function clearIssueTypeForm() {
  issueTypeForm.trigger("reset");
}
