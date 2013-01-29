# coding: utf-8

# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  include AuthenticatedSystem

  # render new.rhtml
  

  def new
    respond_to do |format|
        format.html { render :layout => 'login.haml' }
    end
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      
      if user.admin?      
         str = "Вы вошли как заведующий кафедры!" 
      elsif user.secretary?         
         str = "Вы вошли как секретарь!"
      else
         str = "Вход осуществлен!"
      end      
      redirect_back_or_default('/', :notice => str)
    else
      note_failed_signin      
      @login       = params[:login]
      @remember_me = params[:remember_me]
      flash[:error] = 'Неправильный логин или пароль'
      redirect_to login_path
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/', :notice => "Выход осуществлен")
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Неправильный логин или пароль"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
