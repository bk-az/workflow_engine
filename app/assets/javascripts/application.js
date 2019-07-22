// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require datatables
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load',function(){
  $("table[role='datatable']").each(function(){
    $(this).DataTable({
      processing: true,
      serverSide: true,
      ajax: '/issues.json'
    });
  });
})

$( document ).ready(function() {
  $('#drop').change(function() {
    var project_filter = $('#project_filter option:selected').val();
    var assignee_filter = $('#assignee_filter option:selected').val();
    var state_filter = $('#state_filter option:selected').val();
    var type_filter = $('#type_filter option:selected').val();
    var search_filter = $('#search_filter').val();
    $.ajax({
      url: "/issues/filter",
      data: { 
              project_id: project_filter,
              assignee_id: assignee_filter,
              issue_state_id: state_filter,
              issue_type_id: type_filter,
              search_filter: search_filter
            }
    });
  });
});
