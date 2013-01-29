# coding: utf-8

class Protocol < ActiveRecord::Base
  # при создании установить номер протокола в году
  before_create :check_academic_year
  has_paper_trail
  # загрузка ассоциаций
  scope :full_load, includes(:chairman, :secretary, :auditory, :protocol_template)
  # сортировка по дате
  scope :order_by_date, order("date DESC")

  PER_PAGE = 5
  # состояние заседания
  STATES = ["будет", "идет", "прошло"]
  # время заседания для системы (час)
  TIME = 1.hour
  
  belongs_to :academic_year, :class_name => "AcademicYear"
  belongs_to :chairman, :class_name => "Employee"
  belongs_to :secretary, :class_name => "Employee"
  belongs_to :auditory, :class_name => "Auditory"
  belongs_to :protocol_template, :class_name => "ProtocolTemplate"
  
  has_many :themes, :dependent => :destroy, :order => "themes.created_at"
  has_and_belongs_to_many :employees
  accepts_nested_attributes_for :themes, :reject_if => lambda { |theme| theme[:description].blank? }, :allow_destroy => true
  
  validates :chairman, :presence => true
  validates :secretary, :presence => true
  validates :date, :presence => true  
  validate  :must_be_employees
  validate  :check_date
  
  attr_reader :chairman_token  
  attr_reader :secretary_token
  attr_reader :auditory_token
  attr_reader :employee_protocol_ids
  
  # сравнение протокола с его изменениями из формы (при редактировании)
  def update_changed(tmp_protocol)
     # если поменялся учебный год, обновляем его, шаблон и номер
     if ac_year != tmp_protocol.ac_year
         self.ac_year = tmp_protocol.ac_year 
         self.protocol_template_id = tmp_protocol.protocol_template_id
         #self.number = tmp_protocol.number  #автоматическое обновление номера в зависимости от учебного года
         logger.info "update_changed: OK!"
     end
  end

  def find_templates
    ProtocolTemplate.where("apply_from <= :year and apply_to >= :year", :year => ac_year)
  end
  # поиск и установка шаблона для протокола
  def update_template
      logger.info "update_template():"
      # найти шаблоны, в интервал годов которых попадает учебный год протокола
      templates = find_templates
      return if templates.length == 0  # если таких шаблонов нету ничего не делаем
 	    logger.info "\ttemplate found!"
	    self.protocol_template = templates.last
	    logger.info "\tset template: #{templates.last.name}"
  end

  # проверка на совпадение даты и аудитории
  def check_date
     errors.add(:base, "Заседание не может идти в 0 часов") if date.hour == 0
     query = ["date = ? and auditory_id = ?", date, auditory_id]
     if id
        query[0] += " and id IS NOT ?"
        query << id        
     end
  	errors.add(:base, "Заседание с такой датой и аудиторией уже есть!") if Protocol.where(query).length != 0
  end
    
  
  # проверка номера
  def check_number    
    is_create = id == nil    
    if not is_create and number <= 0
      errors.add(:base, "Номер протокола должен быть больше нуля")
    	return 
    end
    logger.info "check_number"               
     query = ["number = ? and ac_year = ?", number, ac_year]
     if not is_create
        query[0] += " and id IS NOT ?"
        query << id
     end
  	errors.add(:base, "Протокол с таким номером в #{ac_year} учебном году уже есть") if Protocol.where(query).length != 0
  end
                      
  # проверка присутствующих
  def must_be_employees   
     _state = get_state
     return if _state == 0 or _state == 1 # если заседание будет или идет, присутствующих можно не заполнять
  	 errors.add(:base, "Не заполнены присутствующие") if employee_ids.length == 0
  end
  
  # учебные года в виде массива
  def self.get_academic_years
    select("DISTINCT ac_year").order("ac_year DESC").map {|p| p.ac_year }
  end
  # вычислить учебный год
  def get_academic_year
  	year = date.year
  	# если дата меньше чем 1 сентября, учебный год равен предыдущему году
  	year -= 1 if date <= Time.parse("1.09.#{year}")
    year
  end

  # обновить учебный год
  def check_academic_year
     return if not date 
     logger.info "check_ac_year():"
  	 cur_ac_year = ac_year
  	 new_year = get_academic_year
  	 logger.info "\tnew_year = #{new_year}"
     # если он не совпадает с бывшим годом, обновляем его номер и шаблон в соответствии с учебным годом     
     is_changed_year = new_year != cur_ac_year
     self.ac_year = new_year if is_changed_year
     update_number if number == 0 or is_changed_year
	   update_template if cur_ac_year == 0 or is_changed_year
	   logger.info "set ac year: #{ac_year}"
  end

   # обновить номер протокола за учебный год
  def update_number    
    return false if !ac_year
    logger.info "update_number():"
    query = ["ac_year = ?", ac_year]
    # если протокол не новый, выбираем нужные, кроме него
    if id
	    query[0] += " and id IS NOT ?"
	    query << id
    end
    p_year = Protocol.where(query).order("number")    
    self.number = p_year.length != 0 ? p_year.last.number + 1 : 1
    logger.info "\tset number #{number}"
  end
  
  # обновить все номера протоколов в каждом учебном году
  def self.update_all_numbers
  	Protocol.get_academic_years.each do |year|
  	    Protocol.where(:ac_year => year).order("date").each_with_index do |p, i|
  	    		p.number = i+1
  	    		p.save
  	    end
  	end
  end
  
  # проверка присутствующих, сравнение списка присутствующих и участников тем 
  def check_employees
    employee_ids = []
    # проверяем, есть ли участники заседания в списке присутствующих,
    # если нету, добавляем их в список
    self.themes.find_each do |theme|
      theme.participants.each do |p|
        employee_ids << p.employee_id
      end
    end
    self.employee_ids |= employee_ids
  end  
  
  # обновить кол-во тем
  def update_count_themes	
	  self.count_themes = self.themes.count
	  self.save
  end


  # получить состояние заседания
  def show_state     
    return "не определено!" if not state
    STATES[state]
  end
    
  # протокол подписан?
  def signed?
    signed == true
  end    
  
  # подписать протокол
  def set_sign
    self.signed = true
  end
  
  # убрать подпись
  def clear_sign
    self.signed = false
  end

  # установить состояние заседания
  def update_state
      new_state = get_state
      if state != new_state
        self.state = new_state
        self.save
      end
  end

  def self.update_states
    Protocol.find_each {|p| p.update_state }
  end
  # присутствующие
  def employee_protocol_ids=(ids)    
    self.employee_ids = ids.reject(&:blank?)    
  end   
  
  # сотрудник был на заседании?
  def employee?(id)
    self.employees.exists?(id)
  end
  
  # председатель
  def chairman_token=(id)
    self.chairman_id = id
  end  
  
  # аудитория
  def auditory_token=(id)
    self.auditory_id = id
  end  
  
  # секретарь
  def secretary_token=(id)
    self.secretary_id = id
  end  
  
  # список присутствующих через запятую
  def get_employees
    fios = []
    self.employees.find_each do |employee|      
      fios << employee.get_info + " " + employee.fio
    end
    fios = fios.join(", ")
    fios += ", " + invited if !invited.nil? # плюс приглашенные, если есть
    fios
  end
 
 
=begin
Поиск протоколов по сл. данным

номер
учебный год 
аудитория
секретарь
председатель
тема
постановление
слушали
выступали

параметры:

params[:search]
  [:number]["from"]   [:number]["to"]
  [:year]["from"] [:year]["to"]
  [:secrerary]
  [:chairman]
  [:auditory]
  [:theme_description]
  [:theme_decided]
  [:theme_listen]
  [:theme_speak]  
=end

  # метод поиска для модели
  def self.search(options)
    if options[:search].blank?
       Protocol.order_by_date
    else            
      @protocols = ProtocolSearch.new(options[:search]).find
    end
  end

private
  # возвращает состояние заседания в зависимости от времени
  def get_state
    return if not date
    _date = date.utc
    new_state = nil
    time_now = Time.now.utc + 3.hour
    if time_now < _date
      new_state = 0 # будет
    elsif time_now >= _date + TIME
      new_state = 2 # прошло
    elsif time_now >= _date and time_now <= _date + TIME
      new_state = 1 # идет
    end
    return new_state
  end
 
end

 
