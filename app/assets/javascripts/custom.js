// Menu Toggle Script
$(function() {
  var last_child_of_breadcrum = $('#breadcrumb li:last-child');
  last_child_of_breadcrum.html("<a>" + last_child_of_breadcrum.text() + "</a>");

  $('#breadcrumb').parent().hide().removeClass('d-none').slideDown(500);

  function performAjax(url, type, data, successCallback = null, failureCallback = null, beforeSendCallback = null, completeCallback = null ) {
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

  function toggleSidebar(should_collapse) {
    // URL
    var url = '/sidebar_toggle/' + Number(should_collapse);

    var completeCallback = function(result, status, xhr) {
      $("#wrapper").toggleClass("toggled");
    }

    performAjax(url, 'GET', {}, null, null, null, completeCallback);
  }

  $("#js_side_menu_toggle_button").click(function(event) {
      event.preventDefault();
      toggleSidebar(!$("#wrapper").hasClass("toggled"));
  });

  $('.upload-document-field > input').filestyle({
    'text' : 'Choose File',
    'btnClass' : 'btn-secondary',
    'placeholder': 'E.g. review.docs',
    'buttonBefore' : true
  });

});
