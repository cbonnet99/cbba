class UserProfile < ActiveRecord::Base
  include Workflowable
  
  belongs_to :user

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
    "user_path"
  end
end
