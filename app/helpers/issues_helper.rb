# issues_helper.rb
module IssuesHelper
  PRIORITY = {
    Low: 0,
    Medium: 1,
    High: 2
  }.freeze

  def get_priority(priority)
    PRIORITY.key(priority)
  end

  def show_priority
    PRIORITY
  end
end
