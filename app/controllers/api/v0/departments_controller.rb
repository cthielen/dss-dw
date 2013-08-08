module Api
  module V0
    class DepartmentsController < ApplicationController
      before_filter :load_department, :only => :show
      before_filter :new_department_from_params, :only => :create
      filter_access_to :all, :attribute_check => true
      filter_access_to :index, :attribute_check => true, :load_method => :load_departments
      
      def index
        logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded departments index."
        
        render "api/v0/departments/index"
      end
      
      private
      
      def load_departments
        @departments = Department.all
      end
    end
  end
end
