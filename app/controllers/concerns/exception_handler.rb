module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      render json: { message: e.message }, status: :not_found
    end

    rescue_from Mongoid::Errors::InvalidFind do |e|
      render json: { message: e.message }, status: :bad_request
    end

    rescue_from ActionController::ParameterMissing do |e|     
      render json: { message: e.message }, status: :bad_request
    end
  end  
end