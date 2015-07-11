class GlanceyearController < ApplicationController
  unloadable
  before_filter :find_project

  def show
    @activities = activities
  end

  private
  def find_project
    project_id = (params[:issue] && params[:issue][:project_id]) || params[:project_id]
    @project = Project.find(project_id)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def activities
    @activity = Redmine::Activity::Fetcher.new(User.current, :project => @project, :with_subprojects => true)
    events = @activity.events(1.years.ago, Date.today.since(1.days))
    count_map = {}
    events.each do |event|
      if event.respond_to?(:created_on)
          date_formatted = event.created_on.strftime("%Y-%-m-%-d")
          count_map[date_formatted] = 0 unless count_map[date_formatted]
          count_map[date_formatted] += 1
      end
    end
    count_map.map {|k, v| {:date => k, :value => v} }
  end
end
