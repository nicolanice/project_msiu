# coding: utf-8

class UsersController < ApplicationController
  before_filter :check_admin_user
  
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
 
  def index
    @users = User.includes(:employee, :emails)
  end

  def edit
    @user = User.find(params[:id])    
  end

  # render new.rhtml
  def new
    @user = User.new
    @user.emails.build
  end

  
  def update_roles
    if !params[:user].blank?
       params[:user].map do |k, v|
          if User.exists?(k)
            u = User.find(k)
            u.role = v
            u.save
          end
       end
       flash[:notice] = "Права успешно изменены"
    end
    redirect_to users_path
  end

  def create
    #logout_keeping_session!
    @user = User.new(params[:user])
    #raise params[:user].inspect
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      # self.current_user = @user # !! now logged in
      redirect_to users_path, :notice => "Пользователь добавлен в систему"
    else
      flash.now[:error]  = "Невозможно создать пользователя, возможно данные не корректны"
      render :action => 'new'
    end
  end
  
  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'Данные сохранены' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
