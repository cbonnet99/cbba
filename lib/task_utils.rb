require 'xero_gateway'

class TaskUtils

  def self.send_offers_reminder
    users = Set.new
    User.has_paid_special_offers.hasnt_received_offers_reminder_recently.each do |u|
       users << u if u.hasnt_changed_special_offers_recently?
    end
    User.has_paid_gift_vouchers.hasnt_received_offers_reminder_recently.each do |u|
       users << u if u.hasnt_changed_gift_vouchers_recently?
    end
    users.each do |u|
      UserMailer.deliver_offers_reminder(u)
    end
  end

  def self.check_inconsistent_tabs
    User.all.each do |u|
      if u.tabs.size != u.subcategories.size
        puts "User #{u.email} has #{u.tabs.size} tabs (#{u.tabs.map(&:title).to_sentence}), but #{u.subcategories.size} subcategories (#{u.subcategories.map(&:name).to_sentence})."
      end
    end
    puts "Done!"
  end

  def self.recompute_points
    #clean up, just in case
    SubcategoriesUser.all.each do |su|
      su.destroy if su.user.nil?
    end
    SubcategoriesUser.all.each do |su|
      su.update_attribute(:points, su.user.compute_points(su.subcategory))
    end
  end

  def self.notify_unpublished_users
    User.unpublished.notify_unpublished.each do |user|
      if user.count_visits_since(14.days.ago) >= 8        
        UserMailer.deliver_notify_unpublished(user, 14.days.ago)
      end
    end
    
  end

  def self.check_pending_payments
    payments_to_notify = Payment.pending.not_notified
    unless payments_to_notify.blank?
      UserMailer.deliver_alert_pending_payments(payments_to_notify)
    end
    payments_to_notify.each do |p|
      p.update_attribute(:notified_at, Time.now)
    end
  end

  def self.add_feature(feature_names_hash, user, feature_name)
    if feature_names_hash[user].nil?
      feature_names_hash[user] = []
    end
    feature_names_hash[user] << feature_name
  end
  
  def self.check_feature_expiration
    has_expired_feature_names = {}
    expired_feature_names = {}
    expiring_feature_names = {}
    User.with_expired_photo.each do |u|
      u.update_attribute(:paid_photo, false) if u.paid_photo?
      add_feature(expired_feature_names, u, "photo")
    end
    User.with_has_expired_photo.each do |u|
      add_feature(has_expired_feature_names, u, "photo")
    end
    User.with_expiring_photo(7.days.from_now).each do |u|
      add_feature(expiring_feature_names, u, "photo")
    end
    User.with_expired_highlighted.each do |u|
      u.update_attribute(:paid_highlighted, false) if u.paid_highlighted?
      add_feature(expired_feature_names, u, "highlighted profile")
    end
    User.with_expiring_highlighted(7.days.from_now).each do |u|
      add_feature(expiring_feature_names, u, "highlighted profile")
    end
    User.with_expired_special_offers.each do |u|
      feature_count = u.paid_special_offers - u.count_not_expired_special_offers
      add_feature(expired_feature_names, u, help.pluralize(feature_count, "special offer"))
      if feature_count == u.paid_special_offers
        u.update_attribute(:paid_special_offers_next_date_check, nil)
      else
        #move the next check date forward
        next_order_to_expire = u.orders.not_expired.first
        u.update_attribute(:paid_special_offers_next_date_check, next_order_to_expire.created_at+1.year)
      end
      u.update_attribute(:paid_special_offers, u.paid_special_offers-feature_count)
    end
    User.with_expiring_special_offers(7.days.from_now).each do |u|
      feature_count = u.paid_special_offers - u.count_not_expiring_special_offers()
      add_feature(expiring_feature_names, u, help.pluralize(feature_count, "special offer"))
    end
    User.with_expired_gift_vouchers.each do |u|
      feature_count = u.paid_gift_vouchers - u.count_not_expired_gift_vouchers
      add_feature(expired_feature_names, u, help.pluralize(feature_count, "gift voucher"))
      if feature_count == u.paid_gift_vouchers
        u.update_attribute(:paid_gift_vouchers_next_date_check, nil)
      else
        #move the next check date forward
        next_order_to_expire = u.orders.not_expired.first
        u.update_attribute(:paid_gift_vouchers_next_date_check, next_order_to_expire.created_at+1.year)
      end
      u.update_attribute(:paid_gift_vouchers, u.paid_gift_vouchers-feature_count)
    end
    User.with_expiring_gift_vouchers(7.days.from_now).each do |u|
      feature_count = u.paid_gift_vouchers - u.count_not_expiring_gift_vouchers()
      add_feature(expiring_feature_names, u, help.pluralize(feature_count, "gift voucher"))
    end
    has_expired_feature_names.keys.each do |u|
      u.warn_has_expired_features(has_expired_feature_names[u])
    end
    expired_feature_names.keys.each do |u|
      u.warn_expired_features(expired_feature_names[u])
    end
    expiring_feature_names.keys.each do |u|
      u.warn_expiring_features_in_one_week(expiring_feature_names[u])
    end
  end
  
  def self.rotate_feature_ranks
    Article.rotate_feature_ranks
    User.rotate_feature_ranks
  end

  def self.update_individual_counters
    User.full_members.each do |u|
      real_published_articles_count = u.articles.published.size
      real_published_how_tos_count = u.how_tos.published.size
      if u.published_articles_count != real_published_articles_count
        Rails.logger.error "For user #{u.full_name}, changed published_articles_count from: #{u.published_articles_count} to: #{real_published_articles_count}"
        u.update_attribute(:published_articles_count, real_published_articles_count)
      end
      if u.published_how_tos_count != real_published_how_tos_count
        Rails.logger.error "For user #{u.full_name}, changed published_how_tos_count from: #{u.published_how_tos_count} to: #{real_published_how_tos_count}"
        u.update_attribute(:published_how_tos_count, real_published_how_tos_count)
      end
      real_published_gift_vouchers_count = u.gift_vouchers.published.size
      real_published_special_offers_count = u.special_offers.published.size
      if u.published_gift_vouchers_count != real_published_gift_vouchers_count
        Rails.logger.error "For user #{u.full_name}, changed published_gift_vouchers_count from: #{u.published_gift_vouchers_count} to: #{real_published_gift_vouchers_count}"
        u.update_attribute(:published_gift_vouchers_count, real_published_gift_vouchers_count)
      end
      if u.published_special_offers_count != real_published_special_offers_count
        Rails.logger.error "For user #{u.full_name}, changed published_special_offers_count from: #{u.published_special_offers_count} to: #{real_published_special_offers_count}"
        u.update_attribute(:published_special_offers_count, real_published_special_offers_count)
      end
    end
    return "Done!"
  end

  def self.generate_autocomplete
    TaskUtils.generate_autocomplete_subcategories
    TaskUtils.generate_autocomplete_regions    
  end
  
  def self.generate_autocomplete_subcategories
    File.open("#{RAILS_ROOT}/public/javascripts/subcategories.js", 'w') do |out|
      generate_autocomplete_subcategories_content(out)
    end
  end
  
  def self.generate_autocomplete_subcategories_content(out)
    subcategories = Subcategory.find(:all, :order =>:name)
    subcategories.concat(Category.find(:all, :order =>:name))
    subcategories.concat(User.full_members.published)
    out << "var sbg=new Array(#{subcategories.size});"
    subcategories.each_with_index do |stuff, index|
      # puts "Adding #{stuff.name}"
      out << "sbg[#{index}]='#{help.escape_javascript(stuff.name)}';"
    end
  end

  def self.generate_autocomplete_regions
    File.open("#{RAILS_ROOT}/public/javascripts/regions.js", 'w') do |out|
      regions = Region.find(:all, :order => "name" )
      districts = District.find(:all, :order => "name" )
      locations = regions + districts
      out << "var lts = new Array(#{locations.size});"
      locations.each_with_index do |location, index|
        # puts "Adding #{location.name}"
        out << "lts[#{index}]='#{help.escape_javascript(location.name)}';"
      end
    end    
  end
  
  def self.reset_slugs
    Category.all.each do |c|
      c.save!
    end
  end

  def self.extract_numbers_from_reference(ref)
    ref.gsub(/[ -\.]/, "").split(/inv/i)
  end

  def self.process_paid_xero_invoices
    run = Time.now
    response = $xero_gateway.get_invoices(Task.last_run(Task::XERO_INVOICES))
    response.invoices.each do |invoice|
      if invoice.invoice_status == "PAID"
        user_id, invoice_number = extract_numbers_from_reference(invoice.reference)
        payment = Payment.find_by_invoice_number_and_user_id("INV-#{invoice_number}", user_id)
        if payment.nil?
          Rails.logger.error("Payment not found for Xero invoice reference: #{invoice.reference} (user_id: #{user_id}, invoice number: #{invoice_number})")
        else
          payment.mark_as_paid!
          puts "Processed invoice INV-#{invoice_number} for payment"
        end
      end
    end
    Task.set_last_run(Task::XERO_INVOICES, run)
  end
  
  def self.generate_random_passwords
    User.free_users.each do |u|
      u.password = u.password_confirmation = User.generate_random_password
      u.save!
    end
    User.full_members.each do |u|
      u.password = u.password_confirmation = User.generate_random_password
      u.save!
    end
  end
  
  def self.send_reminder_on_expiring_memberships
    User.paying.each do |u|
      if u.resident_expert?
        time_until = u.resident_until
      else
        if u.full_member?
          time_until = u.member_until
        else
          next
        end
      end
      if !time_until.nil?
        if time_until < 3.weeks.ago || time_until > 3.weeks.from_now
          #forget it
          next
        else
          if time_until < 2.weeks.ago
              if u.resident_expert?
                UserMailer.deliver_past_residence_expiration(u, "2 weeks") unless past_membership_reminder_email_sent_in_last_week?(u)
              else
                UserMailer.deliver_past_membership_expiration(u, "2 weeks") unless past_membership_reminder_email_sent_in_last_week?(u)
              end
          else
            if time_until < 1.week.ago
              if u.resident_expert?
                UserMailer.deliver_past_residence_expiration(u, "1 week") unless past_membership_reminder_email_sent_in_last_week?(u)
              else
                UserMailer.deliver_past_membership_expiration(u, "1 week") unless past_membership_reminder_email_sent_in_last_week?(u)
              end
            else
              if time_until < 1.week.from_now
                if u.resident_expert?
                  UserMailer.deliver_coming_residence_expiration(u, "1 week") unless future_membership_reminder_email_sent_in_last_week?(u)
                else
                  UserMailer.deliver_coming_membership_expiration(u, "1 week") unless future_membership_reminder_email_sent_in_last_week?(u)
                end
              else
                if time_until < 2.weeks.from_now
                  if u.resident_expert?
                    UserMailer.deliver_coming_residence_expiration(u, "2 weeks") unless future_membership_reminder_email_sent_in_last_week?(u)
                  else
                    UserMailer.deliver_coming_membership_expiration(u, "2 weeks") unless future_membership_reminder_email_sent_in_last_week?(u)
                  end
                end
              end
            end
          end
      end
    end
  end
 end
  def self.suspend_full_members_when_membership_expired
    User.paying.each do |u|
      if u.resident_expert?
        time_until = u.resident_until
      else
        if u.full_member?
          time_until = u.member_until
        else
          next
        end
      end
      if !time_until.nil? && time_until < Time.now && u.active?
        puts "Suspending #{u.email}"
        u.suspend!
        #send an email
        if u.resident_expert?
          UserMailer.deliver_residence_expired_today(u)
        else
          UserMailer.deliver_membership_expired_today(u)
        end
      end
    end
  end

  def self.mark_down_old_full_members
    User.full_members.new_users.each do |m|
      if !m.member_since.nil? && m.member_since < 1.month.ago
        m.update_attribute(:new_user, false)
      end
    end
  end

  def self.mark_down_old_expert_applications
    ExpertApplication.approved_without_payment.each do |a|
      if a.approved_at < 1.week.ago
        a.approved_at = nil
        a.approved_by_id = nil
        a.time_out!
      end
    end
  end

    def self.rotate_user_positions_in_subcategories
      Subcategory.all.each do |sub|
        s_users = sub.subcategories_users.find(:all, :include => "user", :conditions => "users.free_listing is false")
  #      s_users = SubcategoriesUser.find_by_sql("select su.* from subcategories_users su, users u where su.subactegsu.user_id = u.id and u.free_listing is false order by su.position")
        #if there is only 1, no rotation is needed
  #      puts "========= s_users before: #{s_users.inspect}"
        unless s_users.empty? || s_users.size <= 1
          first = s_users.first
          pos = 1
          s_users.each do |su|
  #          puts "====== su: #{su.inspect}"
            if su != first
  #            puts "====== setting to: #{pos}"
              su.update_attribute(:position, pos)
              pos += 1
            end
          end
          #put first at the end
          first.update_attribute(:position, pos)
        end
  #      puts "========= s_users after: #{s_users.inspect}"
      end    
    end

      def self.rotate_user_positions_in_categories
        Category.all.each do |c|
          c_users = c.categories_users.find(:all, :include => "user", :conditions => "users.free_listing is false")
          #if there is only 1, no rotation is needed
    #      puts "========= c_users before: #{c_users.inspect}"
          unless c_users.empty? || c_users.size <= 1
            first = c_users.first
            pos = 1
            c_users.each do |cu|
    #          puts "====== cu: #{cu.inspect}"
              if cu != first
    #            puts "====== setting to: #{pos}"
                cu.update_attribute(:position, pos)
                pos += 1
              end
            end
            #put first at the end
            first.update_attribute(:position, pos)
          end
    #      puts "========= c_users after: #{c_users.inspect}"
        end    
      end

	def self.count_users
		Category.all.each do |c|
			c.update_attribute(:users_counter, User.count_all_by_subcategories(*c.subcategories))
		end
		Subcategory.all.each do |s|
			s.update_attribute(:users_counter, User.count_all_by_subcategories(s))
		end
	end

  def self.count_offers
		Subcategory.all.each do |s|
			s.update_attribute(:published_special_offers_count, s.special_offers.published.size)
			s.update_attribute(:published_gift_vouchers_count, s.gift_vouchers.published.size)
		end    
  end

	def self.update_counters
		Counter.all.each do |c|
			c.update_attribute(:count, Object.const_get(c.class_name).send("count_published_#{c.title.gsub(/ /, '_').downcase}".to_sym))
		end
	end

#  def self.create_default_roles
#    YAML::load(ERB.new(IO.read(File.dirname(__FILE__) +"/../test/fixtures/roles.yml")).result)
#  end

  #better to call after the exisitg users have been imported (because Norma, Julie, etc. will
  #be listed there as practicioners)
  def self.create_default_admins
    #IMPORTANT: keep the following line to make sure that the admin role exists
    Role.find_or_create_by_name("admin")
    $admins.each do |admin|
      user = User.find_by_email(admin[:email])
      if user.nil?
        unless admin[:region].nil?
          default_region = Region.find_or_create_by_name(admin[:region])
          default_district = District.find_by_name_and_region_id(admin[:district], default_region.id)
          if default_district.nil?
            default_district = District.create(:name => admin[:district], :region_id => default_region.id  )
          end
        end
        unless admin[:category].nil?
          default_category = Category.find_or_create_by_name(admin[:category])
          default_subcategory = Subcategory.find_by_category_id_and_name(default_category.id, admin[:subcategory])
          if default_subcategory.nil?
            default_subcategory = Subcategory.create(:name => admin[:subcategory], :category_id => default_category.id  )
          end
        end
        user = User.new(:accept_terms => "1", :first_name => admin[:first_name], :last_name => admin[:last_name],
          :email => admin[:email], :free_listing => false,
          :professional => true, :subcategory1_id => default_subcategory.nil? ? nil : default_subcategory.id,
          :membership_type => "full_member",
          :password => "monkey", :password_confirmation => "monkey",
          :receive_newsletter => false, :district_id => default_district.nil? ? nil : default_district.id  )
        if user && user.valid?
          user.register!
          user.activate!
          user.add_role("admin")
        else
          puts "Could not create user #{admin[:email]}, because of errors:"
          user.errors.full_messages.each do |m|
            puts "* #{m}"
          end
        end
      else
        if user.free_listing?
          user.update_attributes(:membership_type => "full_member", :free_listing => false )
        end
        user.add_role("admin")
      end
    end
    #finally for Cyrille, remove district and subcategory1_id
    c = User.find_by_email("cbonnet99@gmail.com")
    unless c.nil?
      c.update_attributes(:district_id => nil, :subcategory1_id => nil)
    end
  end

protected
  def self.past_membership_reminder_email_sent_in_last_week?(u)
    last_email_sent = u.user_emails.past_membership_expirations.last
    return !last_email_sent.nil? && last_email_sent.created_at < 1.week.from_now
  end
  def self.future_membership_reminder_email_sent_in_last_week?(u)
    last_email_sent = u.user_emails.future_membership_expirations.last
    return !last_email_sent.nil? && last_email_sent.created_at < 1.week.from_now
  end
end