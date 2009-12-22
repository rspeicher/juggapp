module AuthlogicHelper
  def admin?
    unless current_user.nil?
      return current_user.is_admin?
    else
      return false
    end
  end
  
  def link_to_login_or_logout
    if current_user
      link_to("Sign Out", '/logout', :method => :delete, 
        :confirm => 'Are you sure you want to log out?')
    else
      link_to(image_tag('http://www.juggernautguild.com/public/style_images/splat/key.png', :alt => '') + ' Sign In', '/login')
    end
  end
end