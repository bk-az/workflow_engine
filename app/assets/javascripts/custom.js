// Menu Toggle Script
$(function() {
  $("#js_side_menu_toggle_button").click(function(event) {
      event.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });

  $('.upload-document-field > input').filestyle({
    'text' : 'Choose File',
    'btnClass' : 'btn-secondary',
    'placeholder': 'E.g. review.docs',
    'buttonBefore' : true
  })
});