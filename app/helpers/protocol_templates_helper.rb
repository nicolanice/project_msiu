# coding:utf-8
module ProtocolTemplatesHelper
     # загрузить учебные года для шаблона
	def load_years(year)
	    options = "<option value = '-1'>Не выбрано</option>"
	    years = Protocol.get_academic_years.reverse
   	    last_year = years.last + 1
    	    # плюс 5 лет
	    5.times { |x| years << last_year + x }
	    years.each do |ac|    	      	      
	        if ac == year
      	      options += "<option selected value = #{ac}>#{ac}</option>"
             else     	 
      	      options += "<option value = #{ac}>#{ac}</option>"     	 
     	   end
	    end  	    
	    options.html_safe	    
     end
end
