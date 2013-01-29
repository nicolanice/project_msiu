# coding: utf-8
class Email < ActiveRecord::Base
  include Authentication
  
  belongs_to :user
  
  my_bad_message = "Неверный формат электронной почты"
  
  validates :email, :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => 
                    													#Authentication.bad_email_message
                    													my_bad_message
                    													},
                    :length     => { :within => 6..100 }  
  
end
