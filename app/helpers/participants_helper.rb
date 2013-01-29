# coding: utf-8
module ParticipantsHelper
  def show_participants
  	options = "<option value = #{nil}>Участник</option>"        
    Employee.find_each do |e|        
      options += "<option value = #{e.id}>#{e.long_fio}</option>"
    end  
    options.html_safe
  end
end
