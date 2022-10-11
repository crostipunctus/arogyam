module ApplicationHelper

  def logo 
    link_to image_tag('logo.png', height: 75, width: 75), root_path
  end 

 
end
