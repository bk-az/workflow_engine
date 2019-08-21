// Menu Toggle Script
$(function() {
  var last_child_of_breadcrum = $('#breadcrumb li:last-child');
  if (last_child_of_breadcrum.has('a').length === 0) {
    last_child_of_breadcrum.wrapInner("<a></a>");
  }
  $('#breadcrumb').parent().hide().removeClass('d-none').slideDown(500);

  $("#js_side_menu_toggle_button").click(function(event) {
      event.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });

  $('.upload-document-field > input').filestyle({
    'text' : 'Choose File',
    'btnClass' : 'btn-secondary',
    'placeholder': 'E.g. review.docs',
    'buttonBefore' : true
  });

});
