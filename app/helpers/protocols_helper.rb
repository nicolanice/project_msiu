# coding: utf-8
module ProtocolsHelper
	def edit_access?(protocol)
           u = @current_user
    	   return true if u.admin?
           if u.secretary?
             return protocol.signed? ? false : true
           else
             return false
           end
	end
	
	def load_views(select_type)
	    options_arr = [["Список", 0], ["Группировка по учебным годам", 1]]
	    options = ""	    
	    is_select = ""
	    options_arr.each do |x|	        
	        is_select = "selected=selected" if select_type == x[1]
			options += "<option #{is_select} value = \'#{x[1]}\'>#{x[0]}</option>"
			is_select = ""
	    end
	    options.html_safe
	end
	
	def load_academic_years
	    options = "<option value = '-1'>Выберите учебный год</option>"
	    Protocol.get_academic_years.each do |ac|      
     	 options += "<option value = #{ac}>#{ac}</option>"
	    end  
	    options.html_safe
     end
end
