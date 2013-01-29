class AcademicYear < ActiveRecord::Base
	default_scope :order => "year"
	has_many :protocols
end
