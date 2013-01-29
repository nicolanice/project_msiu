# coding: utf-8

class ProtocolTemplatesController < ApplicationController
  before_filter :check_regular_user
  before_filter :check_secretary_user
  # GET /protocol_templates
  # GET /protocol_templates.json
  def index
    @protocol_templates = ProtocolTemplate.all
    @protocols = []
    if !params[:tid].blank?    
	    @protocols = Protocol.where(:protocol_template_id =>
	                                 params[:tid]).order("date DESC")
	    @protocols = @protocols.page(params[:page]).per(10)
	    auds = Auditory.joins("INNER JOIN protocols ON protocols.id = auditories.id")
	    @auditories, @templates = {}, {}
	    templates = ProtocolTemplate.joins("INNER JOIN protocols ON 	protocols.protocol_template_id = protocol_templates.id")    
	    auds.each {|a| @auditories[a.id] = a.number }
	    templates.each {|t| @templates[t.id] = t.name }        
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :layout => false }
      format.json { render :json => @protocol_templates }
    end
  end

  # GET /protocol_templates/1
  # GET /protocol_templates/1.json
  def show    
    if Protocol.count == 0
		redirect_to protocol_templates_path, :notice => "Не найдено протоколов для просмотра"
    else
		@protocol_template = ProtocolTemplate.find(params[:id])    
		@protocol = Protocol.first
		@protocol_themes = @protocol.themes    
		@chairman = @protocol.chairman.fio    
		@head_of_depart = Employee.first.fio
		@employees = @protocol.get_employees
		@secretary = @protocol.secretary.fio 
		@date = @protocol.date.strftime("%d.%m.%y")    
		@body = ERB.new(@protocol_template.body).result(binding)
		respond_to do |format|		
			format.pdf
			format.html
		end
	end
  end

  # GET /protocol_templates/new
  # GET /protocol_templates/new.json
  def new
    @protocol_template = ProtocolTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @protocol_template }
    end
  end

  # GET /protocol_templates/1/edit
  def edit    
    @protocol_template = ProtocolTemplate.find(params[:id])
    flash[:notice] = "Элементы кода, расположенные между <% и %> изменять не желательно!"
  end

  # POST /protocol_templates
  # POST /protocol_templates.json
  def create
    @protocol_template = ProtocolTemplate.new(params[:protocol_template])

    respond_to do |format|
      if @protocol_template.save
        format.html { redirect_to @protocol_template, :notice => 'Шаблон создан.' }
        format.json { render :json => @protocol_template, :status => :created, :location => @protocol_template }
      else
        format.html { render :action => "new" }
        format.json { render :json => @protocol_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /protocol_templates/1
  # PUT /protocol_templates/1.json
  def update
    @protocol_template = ProtocolTemplate.find(params[:id])

    respond_to do |format|
      if @protocol_template.update_attributes(params[:protocol_template])
        format.html { redirect_to @protocol_template, :notice => "Шаблон изменен #{undo_link}." }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @protocol_template.errors, :status => :unprocessable_entity }
      end
    end
  end
  private

  def undo_link
    view_context.link_to("Отменить последние изменения", revert_version_path(@protocol_template.versions.scoped.last), :method => :post)
  end
end
