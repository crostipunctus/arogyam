module ApplicationHelper

  def logo 
    link_to image_tag('treeicon.png', height: 70, width: 70), root_path, data: {turbo: false}
  end 

 
end
