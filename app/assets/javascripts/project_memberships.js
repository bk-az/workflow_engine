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
//   $.ajaxSetup({
//     headers: {
//       'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
//     }
//   });

//   $(document).on("click", ".js-add-member", function() {
//     let member_id = $(this).parent().attr('data-member-id');
//     let member_type = $(this).parent().attr('data-type');
//     let project_id = $(this).parent().attr('data-project-id');
//     alert( member_type );
//     alert( member_id );
//     alert( project_id );

//     prepare_and_send_request_for_adding_membership(project_id, member_id, member_type)
//   });

//   function perform_ajax(url, type, data, success_callback, failure_callback, before_send_callback = null, complete_callback = null ) {
//     $.ajax({
//       async: true,
//       url: url,
//       type: type,
//       data: data,
//       dataType: 'json',
//       error: failure_callback,
//       success: success_callback,
//       beforeSend: before_send_callback,
//       complete: complete_callback
//     });
//   }

//   function prepare_and_send_request_for_adding_membership(project_id, member_id, member_type) {
//     // URL
//     data = {
//       member_id: member_id,
//       member_type: member_type
//     }

//     let url = `/projects/${project_id}/memberships`;

//     let success_callback = function(result, status, xhr) {
//       alert(xhr.status);
//       alert(result.data);
//     }

//     let failure_callback = function(xhr, txt_status, error_thrown) {
//       failure_msg = `Request for loading user role failed with status code of ${xhr.status} and message of ${error_thrown}`;
//       alert(failure_msg);
//     }

//     let before_send_callback = function() {
//       alert('Sending request');
//     }

//     perform_ajax(url, 'POST', data, success_callback, failure_callback, before_send_callback);
//   }

// });
