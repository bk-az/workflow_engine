$( document ).ready(function() {
    projecMemberType = $('#project_member_type');
    searchName = $('#search_name');
    projectMemberId = $('#project_member_id');
    projectId = $('#project_id');
    memberName = $('#member_name');
    newMembershipForm = $('#new_membership_form');
    memberType = $('#member_type');
    addMemberSearchResultArea = $("#add_member_search_result_area")
  
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
  newMembershipForm.attr("hidden",false);
  memberName.val(memberNameVal);
  projecMemberType.val(memberTypeVal);
  projectMemberId.val(memberIdVal);
  projectId.val(projectIdVal);
  addMemberSearchResultArea.html('');
});

function clearAddMemberModal() {
  addMemberSearchResultArea.html('');
  searchName.val('');
  projecMemberType.val('');
  projectMemberId.val('');
  projectId.val('');
  memberName.val('');
  newMembershipForm.attr("hidden",true);
}

function submitSearchForm() {
  $('#search_form_button').click();
  newMembershipForm.attr("hidden",true);
}
