class Theme < ActiveRecord::Base
  has_paper_trail
  
  LISTEN = 0 # слушали
  SPEAK = 1 # выступили
  QUESTIONS_ASK = 2 # вопросы задали
  FINALE = 3 # заключение
  NOTED = 4 # отметили
  PROPOSED = 5 # предложено
  
  TMP_ID = 0
  
  belongs_to :protocol

  has_many :participants
  has_many :employees, :through => :participants    
 
  attr_reader :listen_participant_ids  
  attr_reader :speak_participant_ids
  attr_accessor :tmp_id
  accepts_nested_attributes_for :participants, :reject_if => lambda { |theme| theme[:message].blank? }, :allow_destroy => true

  validates :description, :presence => true
  
  
  def set_tmpid(id)
  	self.tmp_id = id
  	puts self.tmp_id
  end
  
  def listen_participant_ids=(ids)
    ids = ids.reject(&:blank?)
    self.check_participants(LISTEN, ids)
  end   
    
  def speak_participant_ids=(ids)
    ids = ids.reject(&:blank?)
    self.check_participants(SPEAK, ids)
  end   
  
  def listen?(id)
    self.participants.where(:employee_id => id, :party_type => LISTEN).size != 0    
  end
  
  def speak?(id)
    self.participants.where(:employee_id => id, :party_type => SPEAK).size != 0
  end
    
  def self.check_contain(str)
    str.gsub('<li>', "\\item ").
    	   gsub("<ul>", "\\begin{itemize}").
    	   gsub("<ol>", "\\begin{enumerate}").
    	   gsub("</ul>", "\\end{itemize}").
    	   gsub("</ol>", "\\end{enumerate}").
        gsub('<b>', "\\textbf{").
        gsub('</b>', "}")
  end
  
  def check_participants(party_type, ids)
    p = self.participants
    ids.map do |id|
      participant = p.where(:employee_id => id)
      if participant.size != 0 and participant.first.party_type != party_type
        participant = participant.first
        participant.party_type = party_type
        participant.save
      else
        p.create(:employee_id => id, :party_type => party_type)
      end
    end  
  end
  
  def get_participants
    lp, sp = [],[]
    self.participants.map do |p|
      if p.party_type == LISTEN
        lp << p.employee.fio 
        next
      end
      if p.party_type == SPEAK        
        sp << p.employee.fio
        next
      end
    end
    return lp, sp
  end
    
# in develop
  def _listen_employees
     fios = ""
     participants.each do |p| 
       fios += p.employee.fio 
       fios += p.message
     end
     fios    
  end
  
  def _speak_employees
     fios = ""
     employees.each_with_index do |e, i| 
       fios += e.fio 
       fios += ", " if i < employees.size-1        
     end
     fios    
  end
end
