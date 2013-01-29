# coding: utf-8


class EmployeesController < ApplicationController
  before_filter :check_admin_user
  # GET /employees
  # GET /employees.json
  def index
    deleted = false
    if !params[:deleted].blank?       
      deleted = params[:deleted].to_i == 1 ? false : true
    end    
    @employees = Employee.where(:deleted => deleted).full_load
    
    respond_to do |format|
      format.html   	          			        
      format.json do
        q = params[:q]
        qup = q.mb_chars.downcase.to_s
        @employees= Employee.where("(f LIKE ? OR i LIKE ? OR o LIKE ?)",
        "%#{qup}%", "%#{qup}%", "%#{qup}%").all
        render :json=>@employees.map(&:attributes)
      end
      format.js { render :layout => false }
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = Employee.full_load.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
    @employee = Employee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.full_load.find(params[:id])
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(params[:employee])

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, :notice => 'Сотрудник добавлен' }
        format.json { render :json => @employee, :status => :created, :location => @employee }
      else
        format.html { render :action => "new" }
        format.json { render :json => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.full_load.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        format.html { redirect_to @employee, :notice => 'Сотрудник сохранен' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def delete  
  	employee = Employee.find(params[:id])
  	msg = ""
  	if employee.deleted
  		msg = "Сотрудник уже удален"
  	else
  	  	employee.deleted = true
  		employee.users.delete_all
  		employee.save
  		msg = "Сотрудник и все его аккаунты удалены"
  	end
  	redirect_to employees_path, :notice => msg
  end
  
  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :ok }
    end
  end
end
