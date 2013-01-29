# coding: utf-8

module EmployeesHelper
 	def get_posts
		%w("секретарь председатель преподаватель")
	end
	def show_posts(employee)
		options = "<option value = #{nil}>Выберите должность</option>"		
		Post.all.map do |p|
		 if p.id == employee.post_id  
		   options += "<option selected value = #{p.id}>#{p.name}</option>"
		   next
		 end
	        options += "<option value = #{p.id}>#{p.name}</option>"       
		end
		options.html_safe
	end
	
	def show_academic_title(employee)
		options = "<option value = #{nil}>Выберите звание</option>"		
		AcademicTitle.all.map do |ac|
		 if ac.id == employee.academic_title_id
		 	options += "<option selected value = #{ac.id}>#{ac.name}</option>"
		 	next
		 end
		 options += "<option value = #{ac.id}>#{ac.name}</option>"
		end
		options.html_safe
	end
end
