module Admin::NewslettersHelper
  def newsletter_action(newsletter)
    if newsletter.draft?
      link_to "Publish", :controller => "admin/newsletters", :action => "publish", :id => newsletter.id
    else
      if newsletter.published?
        link_to "Unpublish", :controller => "admin/newsletters", :action => "retract", :id => newsletter.id   
      end
    end
  end
end
