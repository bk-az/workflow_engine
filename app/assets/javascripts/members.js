$(function(){
  /*
            ON LOAD SCRIPT
  */
  var notificationArea = $('#js_ajax_request_notification');

  $('.js-list-group-item').click(function() {
    /*
      => Get currently clicked list item.
      => Get user id from the currently clicked list item.
      => Use this user id to fetch user data through ajax.
      => Display data on view.
    */
    var currentClickedListItem = $(this);
    var currentClickedUserId = currentClickedListItem.attr('data-user-id');

    prepareAndSendRequestForUserData(currentClickedUserId);
  });

  $('#js_change_role_submit').click(function() {
    var currentUserId = $('#js_current_user_id').val();
    var newRoleId = $('#js_role_select').val();

    prepareAndSendRequestForRoleChange(currentUserId, newRoleId);
  });

  /*
            HELPER FUNCTIONS
  */

  function performAjax(url, type, data, successCallback, failureCallback, beforeSendCallback = null, completeCallback = null ) {
    $.ajax({
      async: true,
      url: url,
      type: type,
      data: data,
      dataType: 'json',
      error: failureCallback,
      success: successCallback,
      beforeSend: beforeSendCallback,
      complete: completeCallback
    });
  }

  function prepareAndSendRequestForUserData(userId) {
    // URL
    var url = '/members/privileges/' + userId;

    var successCallback = function(result, status, xhr) {
      // Set user id in hidden field.
      $('#js_current_user_id').val(result.data.user.id);

      // RENDER RESULTS
      var userFullname = `${result.data.user.first_name} ${result.data.user.last_name}`;
      $('#js_user_fullname_heading').html(userFullname);

      var roleOptionSelectorString = '#js_role_select option[value='+ result.data.user.role_id +']';

      // Mark it selected.
      $(roleOptionSelectorString).prop('selected', true);
    }

    var failureCallback = function(xhr, txtStatus, errorThrown) {
      failureMsg = 'Request for loading user role failed with status code of '+ xhr.status +' and message of ' + errorThrown;
      notificationArea.html(prepareNotificationHtml(failureMsg, 'danger'));
    }

    var beforeSendCallback = function() {
      // Empty user name heading
      $('#js_user_fullname_heading').html('');

      // Clear notificationArea
      notificationArea.html('');

      // Add loader class.
      notificationArea.addClass('loader');
    }

    var completeCallback = function (xhr, txtStatus) {
      notificationArea.removeClass('loader');
    }

    performAjax(url, 'GET', {}, successCallback, failureCallback, beforeSendCallback, completeCallback);
  }

  function prepareAndSendRequestForRoleChange(userId, roleId) {
    // PREPARE DATA
    var data = {
      // API demands data to be enclosed in user key.
      user: {
        id: userId,
        role_id: roleId
      }
    }

    // URL
    var url = "/members/edit";

    var successCallback = function(result, status, xhr) {
      notificationArea.html(prepareNotificationHtml('Role changed successfully!', 'success'));

      // Change text for the list item too.
      $('.js-list-group-item.active .js-list-group-item-text').html(result.data.role_name);
    }

    var failureCallback = function(xhr, txtStatus, errorThrown) {
      failureMsg = 'Request for Member role failed with status code of '+ xhr.status +' and message of ' + errorThrown;
      notificationArea.html(prepareNotificationHtml(failureMsg, 'danger'));
    }

    var beforeSendCallback = function() {
      notificationArea.addClass('loader');
    }

    var completeCallback = function (xhr, txtStatus) {
      notificationArea.removeClass('loader');
    }

    performAjax(url, 'PUT', data, successCallback, failureCallback, beforeSendCallback, completeCallback);
  }

  function prepareNotificationHtml(msg, alert_class) {
    html = '<div class="alert alert-' + alert_class + '"><a href="#_" class="close" data-dismiss="alert">&times;</a>' + msg + '</div>';
    return html;
  }
});
