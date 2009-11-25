Factory.define :region do |f|
  f.name "Wellington Region"
end

Factory.define :district do |f|
  f.name "Wellington City"
  f.association :region
end

Factory.define :user do |f|
  f.sequence(:first_name) {|n| "User#{n}"}
  f.last_name "Name"
  f.accept_terms true
  f.association :district
  f.password "foobar"
  f.password_confirmation { |u| u.password }
  f.sequence(:email) { |n| "foo#{n}@example.com" }
end

Factory.define :order do |f|
  f.association :user
  f.photo true
end

Factory.define :payment do |f|
  f.association :user
  f.association :order
  f.payment_card_type "credit_card"
  f.amount 1500
end