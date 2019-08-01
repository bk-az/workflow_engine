$( document ).ready(function() {
    projecMemberType = $('#project_member_type');
    searchName = $('#search_name');
    projectMemberId = $('#project_member_id');
    projectId = $('#project_id');
    memberName = $('#member_name');
    jsNewMembershipForm = $('#js_new_membership_form');
    memberType = $('#member_type');
  
  $('#add_member_modal').on('hidden.bs.modal', function (e) {
    clearAddMemberModal();
  });

  memberType.change(function() {
    submitSearchForm();
  });
  searchName.on('input', function() {
    submitSearchForm();
  });
});

$(document).on("click", ".js-add-member", function() {
  var projectIdVal = $(this).parent().data('project-id');
  var memberNameVal = $(this).data('member-name');
  var memberIdVal = $(this).data('member-id');
  var memberTypeVal = memberType.val();
  jsNewMembershipForm.attr("hidden",false);
  memberName.val(memberNameVal);
  projecMemberType.val(memberTypeVal);
  projectMemberId.val(memberIdVal);
  projectId.val(projectIdVal);
  $("#js_search_result_area").html('');
});

function clearAddMemberModal() {
  $("#js_search_result_area").html('');
  searchName.val('');
  projecMemberType.val('');
  projectMemberId.val('');
  projectId.val('');
  memberName.val('');
  jsNewMembershipForm.attr("hidden",true);
}

function submitSearchForm() {
  $('#search_form_button').click();
  jsNewMembershipForm.attr("hidden",true);
}
