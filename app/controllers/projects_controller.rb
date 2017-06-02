class ProjectsController < ApplicationController
  def index
    @unread = mailbox.inbox(:unread => true).count

    if current_user.project_approver
      @projects = Project.order( :id )
    else
      @projects = current_user.projects.order( :id )
    end
  end

  def new
    @unread = mailbox.inbox(:unread => true).count
    @project = Project.new()
  end

  def create
    @project = Project.new( create_project_params )

    if @project.save
      NotifyLidiyaMailer.new_notification.deliver_now
      redirect_to projects_path
    end
  end

  def edit
    @project = Project.find( params[ "id" ] )

    if request.xhr?
      if params[ "status" ] == "Approve"
        @project.update_attributes( approved: true )
        render partial: "projects/approved", layout: false, locals: { id: params[ "id" ] }
      else
        @project.update_attributes( approved: false )
        render partial: "projects/denied", layout: false, locals: { id: params[ "id" ] }
      end
    end
  end


    private

      def create_project_params
        params.require( :project ).permit( :user_id, :location, :title, :description )
      end
end
