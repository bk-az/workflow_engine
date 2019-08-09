$(document).ready(function(){
  var projectMemberType  = $('#project_membership_project_member_type');
  var projectMemberId    = $('#project_membership_project_member_id');
  var projectId          = $('#project_membership_project_id');
  var selectedMemberType = $('#project_membership_selected_member_type');
  
  projectMembershipSearchText = $('#project_membership_search_text');
  newProjectMembershipForm = $('#new_project_membership_form');
  projectMembershipFlash = $("#project_membership_flash");
  
  $('#project_membership_modal').on('hidden.bs.modal', function (e) {
    clearNewProjectMembershipForm();
    selectedMemberType.val('User');
    projectMembershipFlash.html('');
  });

  selectedMemberType.change(function() {
    clearNewProjectMembershipForm();
  });

  newProjectMembershipForm.find(':submit').click(function(){
    if (projectMemberId.val() == ''){
      alert('Please Select a Member');
      return false;
    }
  });

  var app = window.app = {};
  app.NewMembersihp = function() {
    this._input = projectMembershipSearchText
    this._initAutocomplete();
  };

  app.NewMembersihp.prototype = {
    _initAutocomplete: function() {
      this._input
      .autocomplete({
        source: function(request, response) {
          $.getJSON(
            "/project_memberships/search",
            { term: request.term, project_id: projectId.val(),
              member_type: selectedMemberType.val() }, 
              response
              );
        },
        change: function (event, ui) {
          if (ui.item === null) {
            $(this).val('');
            projectMemberType.val('');
            projectMemberId.val('');
          }
        },
        appendTo: '#project_membership_search_results',
        select: $.proxy(this._select, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
    },
    _select: function(e, ui) {
      this._input.val(ui.item.display_value);
      projectMemberId.val(ui.item.id);
      projectMemberType.val(selectedMemberType.val());
      return false;
    },
    _render: function(ul, item) {
      var markup = [
      '<div class="media p-1 border m-1">',
      '<img class="rounded" src="/assets/' + selectedMemberType.val().toLowerCase() + '.jpg" width="25" height="25"/>',
      '<div class="media-body">',
      '<small class="ml-2">' + item.display_value + '</small>',
      '</div>',
      '</div>'
      ];
      return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
    }
  };

  // new app.NewMembersihp;
});

function clearNewProjectMembershipForm() {
  newProjectMembershipForm.trigger("reset");
  projectMembershipSearchText.val('');
}