class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :get_volunteer

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
  def get_volunteer
    @volunteer = nil
    if session[:user_id]
      @volunteer ||= Volunteer.find(session[:user_id])
    end
  end
end
