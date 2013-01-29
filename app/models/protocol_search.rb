class ProtocolSearch < Search

  def by_number number
    find_from_to("number", number)
  end

  def by_ac_year ac_year
    puts "ACYEAR"
    find_from_to("ac_year", ac_year)
  end

  private
  # поиск от и до
  def find_from_to(field, value)
    query = ""
    from, to = value["from"], value["to"]
    if from.present? and to.present?
      query = ["protocols.#{field} >= ? and protocols.#{field} <= ?", from, to]
    elsif from.present?
      query = ["protocols.#{field} >= ?", from]
    elsif to.present?
      query = ["protocols.#{field} <= ?", to]
    else
      return self
    end
    query
  end

  public
  # по аудитории
  def by_auditory number
    ["protocols.auditory_id in ( select aud.id from auditories as aud\
      where aud.number LIKE ?)", "%#{number}%"]
  end

  # по председателю
  def by_chairman chairman
    ["protocols.chairman_id in ( select employees.id from employees \
      where employees.f LIKE ?)", "%#{chairman}%"]
  end

  # по секретарю
  def by_secretary secretary
    ["protocols.secretary_id in ( select employees.id from employees \
      where employees.f LIKE ?)", "%#{secretary}%"]
  end

  # по названию тем
  def by_theme_description theme_descr
    ["protocols.id in (select themes.protocol_id from themes \
      where themes.description LIKE ?)", "%#{theme_descr}%"]
  end

  # по постановлению тем
  def by_theme_decided theme_decided
    ["protocols.id in ( select themes.protocol_id from themes \
      where themes.description LIKE ?)", "%#{theme_decided}%"]
  end

  # по слушающим
  def by_theme_part_listen theme_part_listen
    ["protocols.id in ( select themes.protocol_id from themes \
      where protocols.id in ( select participants.theme_id from participants \
      where participants.message LIKE ? and participants.party_type = 0))", "%#{theme_part_listen}%"]
  end

  # по выступающим
  def by_theme_part_speak theme_part_speak
    ["protocols.id in ( select themes.protocol_id from themes \
      where protocols.id in ( select participants.theme_id from participants \
      where participants.message LIKE ? and participants.party_type = 1))", "%#{theme_part_speak}%"]
  end

  # подписанные
  def by_signed
    ["signed = ?", true]
  end

  def by_no_signed
    ["signed = ?", false]
  end

  # без шаблона
  def by_without_template without_template
    ["protocol_template_id = ?", nil]
  end

  # без повестки дня
  def by_no_fill
    ["count_themes = ?", 0]
  end
end