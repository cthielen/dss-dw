module Api
  module V0
    class CoursesController < ApplicationController
      before_filter :load_course, :only => :show
      before_filter :new_course_from_params, :only => :create
      filter_access_to :all, :attribute_check => true
      filter_access_to :index, :attribute_check => true, :load_method => :load_courses
      
      def index
        logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded courses index."
        
        render "api/v0/courses/index"
      end
      
      private
      
      def load_courses
        @courses = Course.all
      end
    end
  end
end
