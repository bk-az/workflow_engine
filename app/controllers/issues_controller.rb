class IssuesController < ApplicationController
  def index
    @issues = Issue.all
  end

  def show

  end
end
