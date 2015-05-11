module ApplicationHelper

  #Render page title
  def page_title(page)
    unless page.empty?
      "LilyHub | #{page}"
    else
      "LilyHub"
    end
  end

end
