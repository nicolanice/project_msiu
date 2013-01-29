puts "CREATE TEST DATA:"

errors = []

def add_error(obj)
  msg = []
  obj.errors.full_messages.find_each {|e| msg << e }
  errors << "Errors #{obj.class} : #{msg.join('\n')}"
end


text = [
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit",
  "Sed ut perspiciatis unde omnis iste natus error sit voluptatem",
  "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain",
  "Et harum quidem rerum facilis est et expedita distinctio.",
  "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled",
  "Et harum quidem rerum facilis est et expedita distinctio.",
  "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment",
  "These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice",
  "Untrammelled and when nothing prevents our being able to do what we like best, every pleasure is",
  "To be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty",
  "The obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted.",
  "The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures",
  "He endures pains to avoid worse pains",
  "Nor again is there anyone who loves or pursues or desires to obtain pain of itself",
  "Because it is pain, but because occasionally circumstances occur in which toil and pain",
  "Can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical",
  "Exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses", 
  "To enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure",
  "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti",
  "Atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique",
  "Sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum",
  "Facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil",
  "Impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.",
  "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae",
  "Sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores",
  "Alias consequatur aut perferendis doloribus asperiores repellat",
  "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore",
  "Magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo",
  "Consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized",
  "By the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble",
  "That are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will",
  "Which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish.",
  "In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best",
  "Every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty",
  "The obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted.",
  "The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure",
  "Other greater pleasures, or else he endures pains to avoid worse pains."
]
t_max_index = text.size

posts_data = [
  ["zav. kaf.", "zav.kaf"],
  ["prof.", "prof."],
  ["docent", "docent."],  
  ["starshiy prepod", "st.prep"],  
  ["assistent", "assist."],
  ["dekan fakulteta", "d.f."]  
]

#degrees_data = [
#  "�.�", "�.�", "�.�.�", "�.�.�", "�.�.��"
#]

auds_data = [1310, 1410, 2204, 2217, 1209, 1710, 2205, 1210, 1202, 1201, 1204, 2216].shuffle

puts "POSTS"
posts_data.each { |p| 
  post = Post.new(:name => p[0], :short_name => p[1])
  add_error(post) if !post.save  
}

#puts "DEGREES"
#degrees_data.each {|d|
#  degree = Degree.new(:name => d)
#  add_error(degree) if !degree.save  
#}

puts "AUDITORIES"
auds_data.each {|a|
  aud = Auditory.new(:number => a.to_s)
  add_error(aud) if !aud.save  
}

if errors.size != 0
  raise "Errors! #{errors.join('\n')}"
end


#����������
puts "EMPLOYEES"

rea = Employee.create(:f => "Roganov", :i => "Evgeniy", :o=> "Aleksandrowich", :post_id => Post.first.id)
bim = Employee.create(:f => "������", :i => "�����", :o=> "����������", :post_id => Post.find_by_name("docent.").id)
tvi = Employee.create(:f => "��������", :i => "��������", :o=> "��������", :post_id => Post.find_by_name("������").id)
rvu = Employee.create(:f => "�������", :i => "������", :o=> "�������", :post_id => Post.find_by_name("������").id)
lnv = Employee.create(:f => "���������", :i => "�������", :o=> "������������", :post_id => Post.find_by_name("������").id)
kdu = Employee.create(:f => "���������", :i => "�������", :o=> "�������", :post_id => Post.find_by_name("������").id)
bds = Employee.create(:f => "����������", :i => "�������", :o=> "���������", :post_id => Post.find_by_name("������").id)
pea = Employee.create(:f => "�������", :i => "�������", :o=> "�������������", :post_id => Post.find_by_name("����� ����������").id)
aai = Employee.create(:f => "�����������", :i => "�������", :o=> "���������", :post_id => Post.find_by_name("���������").id)

if Employee.count != 9
  raise "Employees error!"
end

employees = [rea, bim, tvi, rvu, lnv, kdu, bds, pea, aai]
secretaries = [bim, lnv]
e_max_index = employees.size

logins = "roganov belova tolmachev radigin luckva kupriov burgonsky pushkar aleksandrow".split(" ")

puts "USERS"
i=0
Employee.find_each do |e|  
  login = logins[i]
  u = User.new(:login=>login, :password=>"111111", :password_confirmation=>"111111")          
  if i==0
    u.role = 1
  end    
  if i==1 or i==4
    u.role = 2
  end
  u.employee = employees[i]
  if u.save    
    u.emails.create(:email => "#{login}@mail.msiu.ru")
    u.emails.create(:email => "#{login}@msiu.ru")  
  else
    msg = []
    u.errors.full_messages {|e | msg << e}
    raise "Errors #{login}: #{msg.join('\n')}"
  end
  i+=1
end

aud_ids = []
Auditory.find_each {|a| aud_ids << a.id }

#���������
puts "PROTOCOLS"
puts "PROTOCOL 1"
p = Protocol.create(:chairman => rea, :auditory_id => aud_ids[0], :date => "2012-02-10 18:00:00", :secretary => bim)
t = p.themes.create(:description => text[rand(t_max_index)], :decided => text[rand(t_max_index)])
t.participants.create(:employee_id => rea.id, :party_type => 0, :message => text[rand(t_max_index)])
t.participants.create(:employee_id => pea.id, :party_type => 1, :message => text[rand(t_max_index)])
p.check_employees
p.set_state
p.save

puts "PROTOCOL 2"
p = Protocol.create(:chairman => kdu, :auditory_id => aud_ids[1], :date => "2011-12-21 16:00:00", :secretary => lnv)
t = p.themes.create(:description => text[rand(t_max_index)], :decided => text[rand(t_max_index)])
t.participants.create(:employee_id => bim.id, :party_type => 0, :message => text[rand(t_max_index)])
t.participants.create(:employee_id => tvi.id, :party_type => 1, :message => text[rand(t_max_index)])
p.set_sign
p.check_employees
p.set_state
p.save

puts "PROTOCOL 3"
time = Time.now.utc + 3.hours
p = Protocol.create(:chairman => rvu, :auditory_id => aud_ids[2], 
:date => "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min-2}:#{time.sec}", :secretary => lnv)
t = p.themes.create(:description => text[rand(t_max_index)], :decided => text[rand(t_max_index)])
t.participants.create(:employee_id => kdu.id, :party_type => 0, :message => text[rand(t_max_index)])
t.participants.create(:employee_id => bds.id, :party_type => 1, :message => text[rand(t_max_index)])
p.check_employees
p.set_state
p.save




s_max_index = secretaries.size
a_max_index = aud_ids.size


def get_rnd_data
  return "2011-#{rand(11)+1}-#{rand(25)+1} #{rand(9)+9}:#{rand(59)}:00"
end


i = 4
50.times{
   puts "PROTOCOL #{i}"
   chairman = employees[rand(e_max_index)].id   
   secretary = secretaries[rand(s_max_index)].id 
   auditory = aud_ids[rand(a_max_index)]
   p = Protocol.create(:chairman_id => chairman, :auditory_id => auditory, :date => get_rnd_data, :secretary_id => secretary)
   (rand(3)+1).times {
      t = p.themes.create(:description => text[rand(t_max_index)], :decided => text[rand(t_max_index)])      
      (rand(3)+1).times {
        t.participants.create(:employee_id => employees[rand(e_max_index)].id, :party_type => 0, :message => text[rand(t_max_index)])
        t.participants.create(:employee_id => employees[rand(e_max_index)].id, :party_type => 1, :message => text[rand(t_max_index)])
      }
   }
   p.set_sign
   p.check_employees
   p.set_state
   p.save
   i+=1
}


puts "Done!"

