# coding: utf-8
class ProtocolsController < ApplicationController
  
  before_filter :check_regular_user
  before_filter :check_secretary_user, :only => ['new', 'edit']
  before_filter :can_edit?, :only => 'edit'
  before_filter :can_set_sign?, :only => 'set_sign'
  # before_filter :update_states, :only => "index"
  # GET /protocols
  # GET /protocols.json
  def index
    @is_search = !params[:is_search].blank? ? true : false    
    @protocols = Protocol.search(params)
    @finded = @protocols.length if @is_search
    @protocols = @protocols.page(params[:page]).per(Protocol::PER_PAGE).full_load
    respond_to do |format|
      format.html
      format.js { render :layout => false }                  
    end
  end

  # GET /protocols/1
  # GET /protocols/1.json
  def show
    @protocol = Protocol.full_load.find(params[:id])    
    if not @protocol.protocol_template
      flash[:error] = "Не найден шаблона для этого протокола в #{@protocol.ac_year} учебном году"
      redirect_to protocols_path
    else    
      @protocol_themes = @protocol.themes
      themes = params[:themes]
      if !params[:commit].blank?
        if !themes.blank?      
          @protocol_themes = @protocol.themes.find(params[:themes])
          @is_extract = true
        else
          flash[:error] = "Не выбраны темы для выписки" 
          redirect_to protocol_path(@protocol)
          return
        end           
      end            
      @chairman = @protocol.chairman.fio
      @secretary = @protocol.secretary.fio
      @head_of_depart = Employee.first.fio
      @employees = @protocol.get_employees    
      @date = @protocol.date.strftime("%d.%m.%y")
      body = @protocol.protocol_template.body
      @body = ERB.new(body).result(binding)
      respond_to do |format|    
        format.pdf
        format.html
      end
    end
  end

  # GET /protocols/new
  # GET /protocols/new.json
  def new
    @protocol = Protocol.new(:chairman => Employee.first, :secretary => Employee.last, :auditory => Auditory.last, :date => Time.now)          
    @protocol_is_new = true
    @protocol_path = new_protocol_path(@protocol)
    if !params[:select_theme].blank?
       @load_theme = Theme.find(params[:select_theme])            
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @protocol }
      format.js { render :layout => false }      
    end
  end

  # GET /protocols/1/edit
  def edit 
    @protocol = Protocol.full_load.find(params[:id])
    @protocol.date = @protocol.date.strftime("%d.%m.%Y %H:%M")
    @protocol_path = edit_protocol_path(@protocol)
    select_theme = params[:select_theme]
    if !select_theme.blank?
        if Theme.exists?(select_theme)
	        @load_theme = select_theme == '-1' ? " " : Theme.find(select_theme)
	   end
    end
    respond_to do |format|
      format.html
      format.js { render :layout => false }           
    end
  end

  # POST /protocols
  # POST /protocols.json
  def create
    is_conference = false      
    if !params[:is_conference].blank?
         is_conference = true
    end
    @protocol = Protocol.new(params[:protocol])                  
    respond_to do |format|
      if @protocol.save
        @protocol.update_count_themes 
        @protocol.check_employees 
        @protocol.date = @protocol.date.strftime("%d.%m.%Y %H:%M")  
        if not is_conference
         format.html { redirect_to protocols_path, :notice => "Протокол создан. #{undo_link}#{sign_str}. #{view_link}." }            
        else
         format.html { redirect_to conferences_path, :notice => "Заседание добавлено. #{undo_link}#{sign_str}." }            
        end
        format.json { head :ok }
      else        
        format.html { render :action => "new" }        
        format.json { render :json => @protocol.errors, :status => :unprocessable_entity }
      end
    end    
  end
  


  # PUT /protocols/1
  # PUT /protocols/1.json
  def update        
      # is_conference - откуда пришел запрос, с формы заседания или с формы протокола
      is_conference = false      
      if !params[:is_conference].blank?
         is_conference = true
      end
      @protocol = Protocol.full_load.find(params[:id])     
      tmp_protocol = Protocol.new(:date => Time.parse(params[:protocol][:date]))      
      tmp_protocol.check_academic_year      
      @protocol.update_changed(tmp_protocol)	 
      sign_str = ""
      if @protocol.signed?
         @protocol.clear_sign 
         sign_str = " и ждет подписи."
      end
      respond_to do |format|
        if @protocol.update_attributes(params[:protocol])
           @protocol.update_count_themes 
           @protocol.check_employees     
           @protocol.date = @protocol.date.strftime("%d.%m.%Y %H:%M")  
          if not is_conference
           format.html { redirect_to protocols_path, :notice => "Протокол сохранен. #{undo_link}#{sign_str}. #{view_link}." }            
          else
           format.html { redirect_to conferences_path, :notice => "Изменения сохранены. #{undo_link}#{sign_str}." }            
          end
           format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @protocol.errors, :status => :unprocessable_entity }
        end
      end      
  end

  # поставить подпись
  def set_sign
    msg = "" 
    @protocol = Protocol.find(params[:id])
    path = protocol_path(@protocol)
    if @protocol.signed?
      msg = "Протокол уже подписан!"
    else
      if @protocol.themes.count == 0
        msg = "Протокол не заполнен!"        
      else    
        @protocol.signed = true    
        if @protocol.save        
          path = protocols_path
          msg = "Протокол подписан!"
        else
          msg = "Невозможно сохранить протокол! Ошибки: #{@protocol.errors}"
        end 
      end
    end
    redirect_to path, :notice => msg
  end
  
  # установить шаблон
  def set_template      
	  msg = ""	
  	if !params[:dates].blank?
  	  params[:dates].map do |template|   	  	
		  year_from = template[1][:from].to_i
		  year_to = template[1][:to].to_i
		  t = ProtocolTemplate.find(template[0])	  		
      if year_from == -1 or year_to == -1
     		t.apply_from = nil
	  		t.apply_to = nil
	  		t.save
	  		next
      end
          protocols = Protocol.where("ac_year >= ? and ac_year <= ?", year_from, year_to)
          next if protocols.size == 0
 	  	protocols.each do |p| 	  		
			if p.protocol_template_id != template[0].to_i
				p.protocol_template_id = template[0].to_i
				p.save
			end		 
  		end  		
  		t.apply_from = year_from
  		t.apply_to = year_to
  		t.save
  	  end	      
	  	msg = "Шаблон успешно применен"
  	else
	  	msg = "Не удалось применить шаблон, ошибка параметров"		
  	end
  	redirect_to protocol_templates_path, :notice => msg
  end

  def get_number
     return if params[:date].blank?
  	number = Protocol.get_number(params[:date])
  	number = {"number" => number}
  	respond_to do |format|
  	  format.json { render :json => number.to_json }
  	end
  end

private

  def update_states
    Protocol.update_states
  end

  def view_link
    view_context.link_to("Посмотреть в PDF", protocol_path(@protocol, :format => :pdf))
  end
  
  def undo_link
    view_context.link_to("Отменить последнее действие", revert_version_path(@protocol.versions.scoped.last), :method => :post)
  end
  
  def can_set_sign?
    return if @current_user.admin?              
    redirect_to protocols_path, :notice => "Протокол может подписать только заведующий кафедры!"
  end


  def can_edit?
    if @current_user.admin?
      return
    end    
    id = params[:id]    
    if id.blank?
      return
    else       
      if @current_user.secretary?
        if Protocol.exists?(id)
          p = Protocol.find(id)
          if p.signed?
            redirect_to protocols_path, :notice => "Протокол подписан, редактировать его нельзя!"
          end               
        else
          flash[:error] = "Протокол не найден!"
          redirect_to protocols_path
        end
      else
        redirect_to protocols_path, :notice => "Нет доступа!"
      end
    end
  end
  
end
