module ApplicationHelper
  def page_title(*args)
    args.push('Juggernaut Guild')
    content_for(:page_title) { args.join(' :: ') }
  end
  
  def breadcrumb(*args)
    # Insert the first breadcrumb, it's always the same
    content_for(:breadcrumb) { content_tag(:li, link_to('Juggernaut Guild', 'http://www.juggernautguild.com/'), :class => 'first') }

    # Insert the supplied arguments
    args.each do |arg|
      content_for(:breadcrumb) { content_tag(:li, arg) }
    end
  end
end
