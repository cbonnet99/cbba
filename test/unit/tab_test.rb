require File.dirname(__FILE__) + '/../test_helper'

class TabTest < ActiveSupport::TestCase
  def test_reserved
    cyrille = users(:cyrille)
    new_tab = Tab.new(:title => "Articles", :user_id => cyrille.id )
    assert ! new_tab.valid?
    assert_equal "^Articles is a reserved title", new_tab.errors[:title]
  end
end
