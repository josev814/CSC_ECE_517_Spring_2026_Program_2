class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :get_volunteer
  before_action :set_admin
  helper_method :admin_access_only
  helper_method :is_admin?
  # helper_method :user_or_admin_access_only

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
  # Gets the current volunteer that's logged in or sets volunteer user to nil
  # @note we use ||= to prevent a db hit if the volunteer is already set
  # @return nil | Volunteer
  def get_volunteer
    @volunteer = nil
    if session[:user_id]
      @volunteer ||= Volunteer.find(session[:user_id])
    end
  end

  # Checks if the user is admin and redirects to homepage if they aren't
  # @note This is useful to restrict access to pages for admin use
  # @return bool|redirect
  def admin_access_only
    if is_admin?
      return true
    end
    redirect_to root_path, alert: "You do not have access to that page"
  end

  # checks if admin is loged in
  # @return bool
  def is_admin?
    @admin.nil?.eql?(false)
  end

  # Sets the admin user only if admin is nil and session has admin_id set
  def set_admin
    if @admin.nil? && session[:admin_id]
      @admin ||= Admin.find_by(id: session[:admin_id])
    end
  end
end
