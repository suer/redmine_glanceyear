class GlanceyearController < ApplicationController
  unloadable
  before_filter :find_project

  def show
    @authors = @project.assignable_users
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
    @include_subproject = params[:include_subproject].blank? ? false : params[:include_subproject]
    @author_id = params[:author_id] || ''
    options = {
      :project => @project,
      :with_subprojects => @include_subproject
    }
    options.merge!(:author => User.find(@author_id)) unless @author_id.blank?

    @activity = Redmine::Activity::Fetcher.new(User.current, options)
    events = @activity.events(1.years.ago, Date.today.since(1.days))
    count_map = {}
    events.each do |event|
      [:created_on, :committed_on].each do |created_on|
        if event.respond_to?(created_on)
            date_formatted = event.send(created_on).strftime("%Y-%-m-%-d")
            count_map[date_formatted] = 0 unless count_map[date_formatted]
            count_map[date_formatted] += 1
        end
      end
    end
    count_map.map {|k, v| {:date => k, :value => v} }
  end
end
