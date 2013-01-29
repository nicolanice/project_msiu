# coding: utf-8

class Employee < ActiveRecord::Base
	scope :full_load, includes(:post, :degrees, :academic_title)
  
	belongs_to :post
	belongs_to :academic_title
	belongs_to :user, :dependent => :destroy
	has_many :participants
	has_many :themes, :through => :participants
	has_and_belongs_to_many :protocols
	has_and_belongs_to_many :degrees	  		  

  attr_reader :employee_degree_ids

  validates :f, :presence => true,
                :length => { :within => 2..30 },
                :format => /^[A-Z,А-Я]{1}[a-z,а-я]{2,30}$/i
                
  validates :i, :presence => true,
                :length => { :within => 2..30 },
                :format => /^[A-Z,А-Я]{1}[a-z,а-я]{2,30}$/i
                
  validates :o, :presence => true,
                :length => { :within => 2..30 },
                :format => /^[A-Z,А-Я]{1}[a-z,а-я]{2,30}$/i  
  
  def fio
      "#{i.first}. #{o.first}. #{f}"    
  end    
  
  def long_fio
      "#{f} #{i} #{o}"
  end    
  
  def degree?(id)
     self.degrees.exists?(id)    
  end
  
  def get_info
  	info = []
  	if !post.nil?
  		pname = post.short_name
  		pname += '.' if pname[-1] != 46 # '.'
  		info << pname
  	end
  	if !academic_title.nil?
  		ac_title = academic_title.short_name
  		ac_title += '.' if ac_title[-1] != 46 # '.'
  		info << ac_title
  	end
  	degrees = show_degrees
  	info << show_degrees if !degrees.empty?
  	info.join(", ")
  end
  
  def show_degrees
  	tmp = []
  	self.degrees.each do|degree|
  		dname = degree.name
  		dname += '.' if dname[-1] != 46 # '.'
  		tmp << dname
  	end
  	tmp.join(", ")
  end
  
  def employee_degree_ids=(ids)
    self.degree_ids = ids.reject(&:blank?)    
  end
end
