//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

$(function() {
  $('.comment_edit_form').hide(); //Initially form will be hidden.

  $(document).on("click", "#cancel_comment_edit", function() {
    var commentID = $(this).attr('data-comment-id');
    $("#this_comment_content_" + commentID).show();
    $("#comment_edit_form_" + commentID).hide();
    var prevContent = $("#this_comment_content_" + commentID).html();
    $("#comment_edit_form_" + commentID + " #comment_update").val(prevContent);
  });
});
