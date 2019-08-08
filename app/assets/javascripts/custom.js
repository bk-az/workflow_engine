// Menu Toggle Script
$(function() {
  $("#js_side_menu_toggle_button").click(function(event) {
      event.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });

  $('.upload_document_field > input').filestyle({
    'text' : 'Choose File',
    'btnClass' : 'btn-secondary',
    'placeholder': 'E.g. review.docs',
    'buttonBefore' : true
  })
});