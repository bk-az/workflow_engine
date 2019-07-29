$( document ).ready(function() {
  $('.js-close-search').on("click", function() {
    clearAddMemberModal();
  });
  $('#member_type').change(function() {
    submitSearchForm();
  });
  $('#search_name').on('input', function() {
    submitSearchForm();
  });
});

  $(document).on("click", ".js-add-member", function() {
    var projectId = $(this).parent().data('project-id');
    var memberName = $(this).data('member-name');
    var memberId = $(this).data('member-id');
    var memberType = $('#member_type').val();
    $('#js_new_membership_form').attr("hidden",false);
    $('#member_name').val(memberName);
    $('#project_member_type').val(memberType);
    $('#project_member_id').val(memberId);
    $('#project_id').val(projectId);
    $("#js_search_result_area").html('');
  });

function clearAddMemberModal() {
  $("#js_search_result_area").html('');
  $('#search_name').val('');
  $('#projec_member_type').val('');
  $('#projec_member_id').val('');
  $('#project_id').val('');
  $('#member_name').val('');
  $('#js_new_membership_form').attr("hidden",true);
}

function submitSearchForm() {
  $('#search_form_button').click();
  $('#js_new_membership_form').attr("hidden",true);
}
