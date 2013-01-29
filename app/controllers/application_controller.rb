# coding: utf-8

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery

  before_filter :check_user

  private
  def check_user
    @current_user = current_user
  end

  def check_regular_user
    unless @current_user
      redirect_to login_path, :notice => "Вы не авторизованы"      
    end
  end
  
  
  
  def check_secretary_user    
    return if @current_user && @current_user.admin?
    unless @current_user && @current_user.secretary?
      redirect_to protocols_path, :notice => "Доступ только для заведующего кафедрой и секретаря!"       
    end
  end

  def check_admin_user
    unless @current_user && @current_user.admin?
      redirect_to protocols_path, :notice => "Доступ только для заведующего кафедрой"
    end
  end
end
