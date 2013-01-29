class Participant < ActiveRecord::Base
  belongs_to :theme
  belongs_to :employee  
end
