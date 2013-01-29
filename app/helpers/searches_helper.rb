module SearchesHelper
  def search_text_field field
    text_field_tag "search[#{field}]", (params[:search]["#{field}"]  if params[:search]), :style => "width: 50px;"
  end

  def search_text_field_from field
    text_field_tag "search[#{field}][from]", (params[:search]["#{field}"]["from"]  if params[:search]), :style => "width: 50px;"
  end

  def search_text_field_to field
    text_field_tag "search[#{field}][to]", (params[:search]["#{field}"]["to"]  if params[:search]), :style => "width: 50px;"
  end

  def search_check_box field
    check_box_tag "search[#{field}]", (params[:search] ? params[:search]["#{field}"] : nil)
  end
end
