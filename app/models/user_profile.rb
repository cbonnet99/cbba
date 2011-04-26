class UserProfile < ActiveRecord::Base
  include Workflowable
  
  aasm_state :unconfirmed
  aasm_initial_state :unconfirmed

  aasm_event :confirm do
    transitions :from => :unconfirmed, :to => :draft
  end
  
  
  belongs_to :user

  def self.last_published_at(country)
    self.first(:include => :user, :order=>"published_at DESC", :conditions=>["users.country_id = ? and published_at IS NOT NULL", country.id]).try(:published_at)
  end
  
  def summary
    "#{user.full_name}: #{user.expertise}"
  end
  
  def author
    user
  end

  def self.count_reviewable
    self.count_by_sql("select count(p.*) as count from users u, user_profiles p where p.user_id = u.id and u.free_listing is false and p.approved_by_id is null and p.state='published'")
  end
  def self.reviewable
    self.find_by_sql("select p.* from users u, user_profiles p where p.user_id = u.id and u.free_listing is false and p.approved_by_id is null and p.state='published'")
  end

  def title
    "#{user.name}'s profile"
  end

  def path_method
    "expanded_user_url"
  end
end
