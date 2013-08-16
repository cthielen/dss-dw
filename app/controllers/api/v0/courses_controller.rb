module Api
  module V0
    
    # Technically queries 'CourseOfferings' not 'Courses'
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
        # /api/v0/courses -> no params[:department_id]
        # /api/v0/department/HIS/courses -> params[:department_id] exists
        #                                   params[:department_id] may be '5' (id) or it may be 'HIS' (code)

        # Default to the latest term
        if params[:term_id]
          term = Term.find_by_code(params[:term_id])
        else
          # Latest term is has the highest value code
          term = Term.find(:first, :order => 'code DESC')
        end
        
        # Nested in /department?
        if params[:department_id]
          @department = Department.find_by_code(params[:department_id])
          
          @courses = CourseOffering.includes(:course).includes(:instructor).includes(:college).where(:department_id => @department.id, :term_id => term.id)
        else
          @courses = CourseOffering.includes(:course).includes(:instructor).includes(:college).includes(:department).where(:term_id => term.id)
        end
      end
    end
  end
end
