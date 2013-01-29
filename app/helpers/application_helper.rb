# coding: utf-8

module ApplicationHelper


  
  def select_roles(cur_role)
    roles = User.get_roles
    options = "<option value = #{cur_role}>#{roles[cur_role]}</option>"    
    roles.each_with_index do |name, i|            
        options += "<option value = #{i}>#{name}</option>" if i != cur_role        
    end
    options.html_safe
  end


  def icon_search
	  image_tag("/images/ico-search.png", :title => "Поиск протоколов")
  end
  
  def icon_loader
    image_tag("/images/loader.gif",
    :alt => "Загрузка...", :title => "Загрузка...")
  end
  
  def icon_delete
    image_tag("/images/ico-delete.gif")
  end
  
  def icon_add
    image_tag("/images/ico-add.png")
  end
  
  def icon_edit
    image_tag("/images/ico-edit.png")
  end
  
  def icon_pdf
    image_tag("/images/ico-pdf.png")
  end
  
  def icon_html
    image_tag("/images/ico-html.png")
  end
  
  def icon_signed
    image_tag("/images/ico-signed.png", :style => "paddng: 10px", :title => "Подписан")
  end
  
  def icon_no_signed
    image_tag("/images/ico-no-signed.png", :style => "paddng: 10px", :title => "Не подписан")
  end
  
  def listen
    0
  end
  
  def speak
    1
  end  
  
  def chairman
    1
  end
  
  def secretary
    2
  end
  
  def lesc(text)
    LatexToPdf.escape_latex(text)
  end
  
  def link_to_remove_fields(name, f)    
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association, ptype = nil)    
    path = "/participants/"
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      assoc = association.to_s.singularize
      if ptype == listen
         assoc = path + "listen"
      elsif ptype == speak
         assoc = path + "speak"
      end
      render( assoc, :f => builder).html_safe
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')")
  end
  
  def link_to_add_theme(name, f, association, load_theme)    
    theme = f.object.class.reflect_on_association(association).klass.new    
    theme.description = load_theme.description
    theme.decided = load_theme.description    
    theme.set_tmpid(load_theme.id)
    load_theme.participants.find_each do |p|
        t = theme.participants.build
        t.employee_id = p.employee_id
        t.message = p.message
        t.party_type = p.party_type
    end
    fields = f.fields_for(association, theme, :child_index => "new_#{association}") do |builder|
      assoc = association.to_s.singularize
      render("theme", :f => builder, :lth => load_theme.id ).html_safe
    end
    link_to_function(name, "add_theme_fields(this, '#{association}', '#{escape_javascript(fields)}')")
  end
  
  # 0 - description, 1 - decided, 2 - messages 
  def load_themes
    options = "<option value = '-1'>Выберите тему</option>"        
    themes = {}
    Theme.find_each {|t| themes[t.description] = t.id}
    themes.map do |theme, id|      
      options += "<option value = #{id}>#{theme}</option>"
    end  
    options.html_safe
  end
  
  def load_dict
    dict = ["выступил с докладом", "утвердил", "представил"]
    options = "<option value = '-1'>Выберите слово из словаря</option>"
    dict.each do |w|      
      options += "<option value = #{w}>#{w}</option>"
    end  
    options.html_safe
  end
  
  
  
  def show_participants
  	options = "<option value = #{nil}>Участник</option>"        
    Employee.find_each do |e|        
      options += "<option value = #{e.id}>#{e.long_fio}</option>"
    end  
    options.html_safe
  end
  
  def count_theme_str(pcount)	
      str = "темa"
      str = "темы" if pcount > 1
      str
  end
  
  def protocol_prev_link(protocol)
    return protocol_path(Protocol.last)  if protocol.id == Protocol.first.id
  	prev_p = Protocol.order(:id).where("id < ?", protocol.id).last
	  prev_p.nil? ? '#' : protocol_path(prev_p) 
  end
  
  def protocol_next_link(protocol)
    return protocol_path(Protocol.first)  if protocol.id == Protocol.last.id
  	next_p = Protocol.order(:id).where("id > ?", protocol.id).first	
	  next_p.nil? ? '#' : protocol_path(next_p) 
  end
    
end
