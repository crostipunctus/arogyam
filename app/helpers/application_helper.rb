module ApplicationHelper

  def logo 
    link_to image_tag('https://d1w11gv0j27jrz.cloudfront.net/symbol.png', class: "no-border-radius", width: 20, alt: 'symbol'), root_path, data: {turbo: false}
  end 

 

  def get_current_url
    request.original_url
  end

 
end
