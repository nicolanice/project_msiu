class ProtocolTemplate < ActiveRecord::Base
    has_paper_trail
    has_many :protocols, :order => "protocols.date DESC"
    validates :name, :presence => true, :uniqueness => true, :length => { :within => 3..50 }
    validates :body, :presence => true
    
    def self.check_html(str)
	    str.gsub('<li>', "\\item ").
    		   gsub("<ul>", "\\begin{itemize}").
    		   gsub("<ol>", "\\begin{enumerate}").
    		   gsub("</ul>", "\\end{itemize}").
    		   gsub("</ol>", "\\end{enumerate}").
     	   gsub('<b>', "\\textbf{").
     	   gsub('</b>', "}")
    end
end
