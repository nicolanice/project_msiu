# coding: utf-8

require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  belongs_to :employee
  
  has_many :emails, :dependent => :destroy

  set_table_name 'users'

  ROLES = ["Авторизованный пользователь", "Зав. кафедрой", "Секретарь"]

  validates :login, :presence   => true,
                    :uniqueness => true,
                    :length     => { :within => 3..40 },
                    :format     => { :with => Authentication.login_regex, :message => Authentication.bad_login_message }

  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 100 },
                    :allow_nil  => true  

  validates :role,:presence=>true,:inclusion => {:in=>0...ROLES.size}

  validates :employee_id, :presence => true
  validates_uniqueness_of :employee_id, :message => "Пользователь на этого сотрудника уже зарегистрирован!"
                         
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :emails_attributes, :employee_id, :name, :password, :password_confirmation

  accepts_nested_attributes_for :emails , :reject_if => lambda { |e| e[:email].blank?}, :allow_destroy => true

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def regular?
    role==0
  end
  
  def show_emails
    emails = []
    self.emails.find_each do |e|
      emails << e.email
    end
    return emails.join(", ")
  end

  def admin?
    role == 1
  end
  
  def secretary?
    role == 2
  end

  def human_role
    ROLES[role]
  end
  
  def self.get_roles
    ROLES
  end

  # метод поиска
  def self.search(options)
    if options[:search].blank?
       self.all
    else
      ps = UserSearch.new(options[:search])
      @users ||= ps.find
    end
  end

end
