module ApplicationHelper

  def logo 
    link_to image_tag('treeicon.png', height: 60, width: 60), root_path, data: {turbo: false}
  end 

 
end
