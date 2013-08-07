class CoursesController < ApplicationController
  before_filter :load_course, :only => :show
  before_filter :new_course_from_params, :only => :create
  #filter_access_to :all, :attribute_check => true
  #filter_access_to :index, :attribute_check => true, :load_method => :load_courses

  # GET /applications
  def index
    logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded courses index."
    
    load_courses # remove me when decl_auth is implemented
    
    render "courses/index"
  end
  
  private
  
  def load_courses
    @courses = Course.all
  end
end
