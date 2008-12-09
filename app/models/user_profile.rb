class UserProfile < ActiveRecord::Base
  include WorkflowSystem
  
  belongs_to :user


  def title
    "#{user.name}'s profile"
  end

  def path_method
    "user_path"
  end
end
