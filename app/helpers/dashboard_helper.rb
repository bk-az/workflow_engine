module DashboardHelper
  def path_for_watching_medium_button(entry)
    return '#_' if entry.through == 'Direct'

    team_path(entry.watcher_id)
  end

  def class_for_watching_medium_button_icon(medium)
    return 'fa-user' if medium == 'Direct'

    'fa-users'
  end
end
