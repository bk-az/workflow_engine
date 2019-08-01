$(document).on('turbolinks:load', function(){
  table = $('#issue_types_datatable').DataTable({
    "info": false
  });
  $('#issue_type_modal').on('hidden.bs.modal', function () {
    clearIssueTypeForm();
    hideProjectSearch();
    clearFlashMessages();
  });

  $("#issue_type_form").submit(function(e){
    if ($('#issue_type_category').val() == 'project' && $('#issue_type_project_id').val() == ''){
      alert('Please Select a Project');
    }
  });

  $('#issue_type_category').change(function() {
    if ($(this).val() == 'global') {
      hideProjectSearch();
      $('#issue_type_project_id').val('');
      $('#project_name').val('');
    } else if ($(this).val() == 'project') {
      showProjectSearch();
    }
  }); 

  $('#issue_types_category_filter').change(function() {
    tr = $('#issue_types_datatable tbody').find('tr');
    tr.show();
    if ($(this).val() == 'global') {
      tr.not(".global").hide();
    } else if ($(this).val() == 'project') {
      tr.filter(".global").hide();
    }
  });

  $('#issue_types_project_name_done').click(function(){
    var id = $('#issue_types_project_id').val();
    if (id == ''){
      alert('Please select a project');
      return false
    }
    $('#issue_types_category_filter').val('project');
    tr = $('#issue_types_datatable tbody').find('tr');
    tr.hide();
    tr.filter('.project-' + id).show();
    return false
  });
} );

function clearIssueTypeForm() {
  $('#issue_type_form').trigger("reset");
  $('#issue_type_form').attr("method","post");
  $('#issue_type_form').attr("action","/issue_types");
}

function clearFlashMessages() {
  $('#issue_type_flash').html('');
  $('#issue_type_errors').html('');
}

function hideProjectSearch() {
  $('#js_project_name_search').attr("hidden",true);
  $('#issue_type_project_id').attr("required",false);
}

function showProjectSearch() {
  $('#js_project_name_search').attr("hidden",false);  
  $('#issue_type_project_id').attr("required",true);
}
