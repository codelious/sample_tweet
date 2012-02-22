module ApplicationHelper
  
  # helper del logo
  def logo
    logo = image_tag("logo.png", alt: "Sample App", class: "round")
  end
  
    # retorna el titulo completo sobre una pagina
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
