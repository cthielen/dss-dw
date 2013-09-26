module Api
  module V0
    class PeopleController < ApplicationController
      before_filter :load_person, :only => :show
      filter_access_to :all, :attribute_check => true
      filter_access_to :index, :attribute_check => true, :load_method => :load_people
      
      def index
        logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded people index."
        
        render "api/v0/people/index"
      end
      
      def show
        if @person
          logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded person view (show) for #{@person.loginid}."
          render "api/v0/people/show"
        else
          logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Attempted to load person view (show) for invalid loginid or IAM ID #{params[:id]}."
          render :text => "Invalid person loginid or IAM ID '#{params[:id]}'.", :status => 404
        end
      end
      
      private
      
      def load_people
        @people = Person.all
      end
      
      def load_person
        @person = Person.find_by_loginid(params[:id])
        @person = Person.find_by_iam_id(params[:id]) unless @person
      end
    end
  end
end
