// Menu Toggle Script
$(function() {
  $("#js_side_menu_toggle_button").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });
});