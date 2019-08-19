$(document).ready(function(){
  issueTypesTable = $('#issue_types_datatable').DataTable({
    "info": false
  });

  issueTypeIssuesModal = $('#issue_type_issues_modal');
  issueTypeModal = $('#issue_type_modal');
  issueTypesTableBody = $('#issue_types_datatable tbody');
  issueTypeFlash = $('#issue_type_flash');
  issueTypesErrors = $('#issue_type_errors');

  var issueTypesCategoryFilter = $('#issue_types_category_filter');
  var issueTypesProjectId = $('#issue_types_project_id');

  issueTypeModal.on('hidden.bs.modal', function () {
    clearFlashMessages();
    $('#issue_type_form_area').html('');
  });

  issueTypeIssuesModal.on('shown.bs.modal', function(){
    issueTypeIssuesTable.columns.adjust();
  });

  issueTypesCategoryFilter.change(function() {
    tr = issueTypesTableBody.find('tr');
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
    tr = issueTypesTableBody.find('tr');
    tr.hide();
    tr.filter('.project-' + id).show();
    return false
  });


  function clearFlashMessages() {
    issueTypeFlash.html('');
    issueTypesErrors.html('');
  }

  $('#issue_type_form_area').on("change", "select", function(){
    if ($(this).val() == 'global') {
      $('#project_search_area').attr("hidden", true);
      $('#project_search_area input').val('');
    } else if ($(this).val() == 'project_specific') {
      $('#project_search_area').attr("hidden", false);
    }
  });

  $('#issue_type_form_area').on("submit", "form", function(){
    var category = $('#issue_type_category').val();
    var project_id = $('#issue_type_project_id').val();
    if (category == 'project_specific' && project_id == ''){
      alert('Please Select a Project');
      return false;
    }
  });
});

function resetIssueTypeCategoryToggle(){
  var categoryToggle = $('#issue_type_category_toggle');
  if (categoryToggle.length > 0) {
    categoryToggle.find('label').removeClass('active');
    categoryToggle.find('label:eq(0)').addClass('active');
  }
}

function issueTypeCategoryToggleSetGlobal(){
  var categoryToggle = $('#issue_type_category_toggle');
  if (categoryToggle.length > 0) {
    categoryToggle.find('label').removeClass('active');
    categoryToggle.find('label:eq(1)').addClass('active');
    categoryToggle.find('input[name=category][value=global]').prop('checked', true);
  }
}
