class HowToStep < ActiveRecord::Base
  belongs_to :how_to
  acts_as_list :scope => :how_to

  validates_presence_of :title, :body

  def label
    if how_to.nil?
      ""
    else
      how_to.step_label.capitalize
    end
  end
end
