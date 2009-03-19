class MassEmail < ActiveRecord::Base

  belongs_to :test_sent_to, :class_name => "User"

  validates_presence_of :subject, :body
end
