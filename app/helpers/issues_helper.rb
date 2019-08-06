# issues_helper.rb
module IssuesHelper
  def get_priority(priority)
    Issue::PRIORITY.key(priority)
  end

  def show_priority
    Issue::PRIORITY
  end
end
