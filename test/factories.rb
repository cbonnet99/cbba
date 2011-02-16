Factory.define :tab do |t|
  t.title "Yoga"
  t.association :user
  t.position 1
  t.slug "yoga"
end
Factory.define :stored_token do |t|
  t.last4digits "1234"
  t.card_expires_on 1.year.from_now
  t.association :user  
  t.billing_id "21323213-2445"
  t.card_number "1"
  t.card_verification "1234"
  t.first_name "Cyrille"
  t.last_name "Bonnet"
end

Factory.define :region do |f|
  f.name "Wellington Region"
  f.country {|c| Country.find_by_country_code("nz")}
end

Factory.define :district do |f|
  f.name "Wellington City"
  f.association :region
  f.country {|c| Country.find_by_country_code("nz")}
end

Factory.define :category do |c|
  c.sequence(:name) {|n| "Cat#{n}"}
  c.slug "coaches2"
end

Factory.define :subcategory do |sc|
  sc.sequence(:name) {|n| "Subcat#{n}"}
  sc.slug "coaching-life2"
  sc.association :category
end

Factory.define :blog_category do |c|
  c.sequence(:name) {|n| "Blog Cat#{n}"}
  c.sequence(:slug) {|n| "blog-cat#{n}"}
end

Factory.define :blog_subcategory do |sc|
  sc.sequence(:name) {|n| "Blog Subcat#{n}"}
  sc.sequence(:slug) {|n| "blog-subcat#{n}"}
  sc.association :blog_category
end

Factory.define :user_profile do |f|
  f.association :user
  f.state "published"
end

Factory.define :role do |f|
  f.name "full_member"
end

Factory.define :special_offer do |so|
  so.author {|author| author.association(:user) }
  so.sequence(:title) {|n| "Trial session #{n}"}
  so.sequence(:description) {|n| "Trial session #{n}"}
  so.association :subcategory
end

Factory.define :gift_voucher do |gv|
  gv.author {|author| author.association(:user) }
  gv.sequence(:title) {|n| "Gift voucher #{n}"}
  gv.sequence(:description) {|n| "Gift voucher #{n}"}
  gv.association :subcategory
end

Factory.define :user do |f|
  f.sequence(:first_name) {|n| "User#{n}"}
  f.last_name "Name"
  f.accept_terms true
  f.association :district
  f.password "foobar"
  f.state "active"
  f.free_listing false
  f.membership_type "full_member"
  f.notify_unpublished true
  f.password_confirmation { |u| u.password }
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  f.subcategory1_id {|s| s.association(:subcategory) }
  f.country {|c| Country.find_by_country_code("nz")}
end

Factory.define :user_event do |e|
  e.event_type UserEvent::VISIT_SUBCATEGORY
  e.logged_at Time.now
  e.remote_ip "202.123.45.2"
  e.association :subcategory
  e.visited_user {|u| u.association(:user)} 
end

Factory.define :subcategories_user do |scu|
  scu.association :user
  scu.association :subcategory
end

Factory.define :country do |c|
  c.country_code "nz"
  c.name "New Zealand"
  c.currency "NZD"
  c.top_domain "co.nz"
end

Factory.define :article do |f|
  f.sequence(:title) {|n| "Article#{n}"}
  f.author {|author| author.association(:user) }
  f.lead "Bla"
  f.body "Bla"
  f.state "published"
  f.published_at Time.now
  f.country {|c| Country.find_by_country_code("nz")}
  f.subcategory1_id {|s| s.association(:subcategory) }
  f.blog_subcategory1_id {|s| s.association(:blog_subcategory) }
end

Factory.define :articles_subcategory do |asu|
  asu.association :article
  asu.association :subcategory
end


Factory.define :order do |f|
  f.association :user
  f.photo true
  f.whole_package false
end

Factory.define :payment do |f|
  f.association :user
  f.association :order
  f.payment_card_type "credit_card"
  f.amount 1500
end

Factory.define :mass_email do |me|
  me.subject "Mass email"
end

Factory.define :newsletter do |f|
  f.title "May newsletter"
  f.state "published"
  f.publisher {|p| p.association(:user) }
  f.author {|author| author.association(:user) }
  f.main_article "This is the main article"
  f.competition "And our great competition"
  f.bam_news "Here are some news"
  f.upcoming_events "Coming soon"
  f.quotation_quiz "Quiz"
end
