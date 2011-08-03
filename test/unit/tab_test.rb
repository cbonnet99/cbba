require File.dirname(__FILE__) + '/../test_helper'

class TabTest < ActiveSupport::TestCase

  def test_subcategory_with_fallback
    subcat = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => subcat.id )
    tab = user.tabs.first
    sub = tab.subcategory_with_fallback
    assert_not_nil sub
    assert_equal subcat.name, sub
  end
  
  def test_set_contents
    subcat = Factory(:subcategory)
    user = Factory(:user, :subcategory1_id => subcat.id )
    yoga = subcategories(:yoga)
    tab = Factory(:tab, :user => user, :subcategory_id => yoga.id, :content => "<h3>Yoga with #{user.name}</h3>CONTENT1<h3>Benefits of Yoga</h3>CONTENT2<h3>Training</h3>CONTENT3<h3>About #{user.name}</h3>CONTENT4" )
    tab.reload
    assert_equal "CONTENT1", tab.content1_with
    assert_equal "CONTENT2", tab.content2_benefits
    assert_equal "CONTENT3", tab.content3_training
    assert_equal "CONTENT4", tab.content4_about
  end
  
  def test_set_contents_missing_title
    user = Factory(:user)
    yoga = subcategories(:yoga)
    tab = Factory(:tab, :user => user, :subcategory_id => yoga.id, :content => "<h3>Yoga with #{user.name}</h3>CONTENT1<h3>Some other random title</h3>RANDOM CONTENT<h3>Training</h3>CONTENT3<h3>About #{user.name}</h3>CONTENT4" )
    tab.reload
    assert_equal "CONTENT1<h3>Some other random title</h3>RANDOM CONTENT", tab.content1_with
    assert_equal "", tab.content2_benefits
    assert_equal "CONTENT3", tab.content3_training
    assert_equal "CONTENT4", tab.content4_about
  end
  
  def test_set_contents_mix
    user = Factory(:user)
    yoga = subcategories(:yoga)
    tab = Factory(:tab, :user => user, :subcategory_id => yoga.id, :content => "<h3>About #{user.name}</h3>CONTENT4<h3>Benefits of Yoga</h3>CONTENT2<h3>Training</h3>CONTENT3<h3>Yoga with #{user.name}</h3>CONTENT1" )
    tab.reload
    assert_equal "CONTENT1", tab.content1_with
    assert_equal "CONTENT2", tab.content2_benefits
    assert_equal "CONTENT3", tab.content3_training
    assert_equal "CONTENT4", tab.content4_about
  end
  
  def test_set_contents_legacy
    user = Factory(:user)
    yoga = subcategories(:yoga)
    content = "<h3>Life Coaching in Wellington with David Savage</h3>\r\n<h4>Goal focused life coaching for people with possibilities in mind!</h4>\r\n<p>Most of us know someone who suddenly made BIG changes in their life to achieve goals important to them. Well&nbsp;Life Coaching helps people create such change and achieve BIGGER and more ambitious goals.</p>\r\n<h3>Coaching for:</h3>\r\n<div>\r\n<ul>\r\n<li>Performers and Creatives</li>\r\n<li>Web-Entrepreneurs and Innovators</li>\r\n<li>Ambitious Athletes</li>\r\n<li>Coaching for Coaches</li>\r\n</ul>\r\n</div>\r\n<h3>FREE Trial Session</h3>\r\n<ul>\r\n<li>Set Primary Goals</li>\r\n<li>Experience being coached</li>\r\n<li>Know my coaching style</li>\r\n<li>THEN, make an informed choice - Yes/No to Coaching</li>\r\n<li>This is a FREE no obligation session</li>\r\n</ul>\r\n<h3>Key benefits</h3>\r\n<div>\r\n<ul>\r\n<li>Achieve significant goals that make a difference</li>\r\n<li>Develop greater mental agility</li>\r\n<li>Apply your strengths and maintain balance</li>\r\n<li>Turn your WHAT IF into WHAT IS</li>\r\n<li>Inspire other people</li>\r\n</ul>\r\n</div>\r\n<h3>My Training</h3>\r\n<ul>\r\n<li>1200+hrs of Coaching</li>\r\n<li>RCS Certified, ICF Aligned Training</li>\r\n<li>Master Certified NLP Practitioner</li>\r\n<li>Transforming Communication Certification</li>\r\n<li>Formally a Trainer &amp; Assessor for Results Coaching Systems</li>\r\n<li>Speaker:&nbsp;Australia &amp; NZ&nbsp;</li>\r\n<li>Knowledge: Neuroscience, Social Intelligence, Adult Learning Theory, Positive Psychology, Solution-Focus Theory, Change Theory, Business Development...</li>\r\n</ul>\r\n<h3>What you can expect...</h3>\r\n<p>Expect to achieve your goals, be supported to make solid decisions, develop a new template for thinking and doing....</p>"
    tab = Factory(:tab, :user => user, :subcategory_id => yoga.id, :content => content )
    tab.reload
    assert_equal content, tab.content1_with, "All the content should go to the first paragraph"
    assert_equal "", tab.content2_benefits
    assert_equal "", tab.content3_training
    assert_equal "", tab.content4_about
  end
  
end
