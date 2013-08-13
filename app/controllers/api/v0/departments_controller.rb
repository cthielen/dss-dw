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
      
      def show
        if @department
          logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded department view (show) for #{@department.code}."
          render "api/v0/departments/show"
        else
          logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Attempted to load department view (show) for invalid code or ID #{params[:id]}."
          render :text => "Invalid department code or ID '#{params[:id]}'.", :status => 404
        end
      end
      
      private
      
      def load_departments
        @departments = Department.all
      end
      
      def load_department
        @department = Department.find_by_id(params[:id])
        @department = Department.find_by_code(params[:id]) unless @department
      end
    end
  end
end
