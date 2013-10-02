class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include Authentication
  before_filter :authenticate
  
  # Check for HTTP 200 at GET /status.json for application status.
  def status
    respond_to do |format|
      format.json { render :json => {
        status: 'ok',
        people_tally: Status.people_tally,
        courses_tally: Status.courses_tally,
        last_iam_import: Status.last_iam_import,
        last_banner_import: Status.last_banner_import
      } }
    end
  end
end
