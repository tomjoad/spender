class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller? || home_controller?
      "landing"
    else
      "application"
    end
  end

  def home_controller?
    params[:controller] == 'home'
  end

  def expense_controller?
    params[:controller] == 'expense'
  end

end
