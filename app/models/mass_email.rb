class MassEmail < ActiveRecord::Base

  belongs_to :test_sent_to, :class_name => "User"
  belongs_to :creator, :class_name => "User"

  before_create :check_newsletter

  validates_presence_of :subject, :body

  TYPES = ["Normal", "Business newsletter", "Public newsletter"]

  RECIPIENTS = {:resident_experts => "Resident experts", :full_members => "Full members",
    :free_users => "Free users", :general_public => "General public"}

  def no_recipients?
    !recipients_full_members? && !recipients_resident_experts? && !recipients_free_users? && !recipients_general_public?
  end

  def check_newsletter
    if email_type == "Business newsletter"
      self.recipients_full_members = true
      self.recipients_resident_experts = true
    end
    if email_type == "Public newsletter"
      self.recipients_full_members = true
      self.recipients_resident_experts = true
      self.general_public = true
      self.free_users = true
    end
  end

  def deliver_test(user)
    UserMailer.deliver_mass_email(user, self.subject, self.transformed_body(user))
    self.test_sent_at = Time.now
    self.test_sent_to = user
    self.save
  end

  def deliver
    if sent_at.nil?
      if email_type == "Public newsletter"
        users_obj = User.active.wants_newsletter
        contact_obj = Contact.wants_newsletter
      else
        if email_type == "Business newsletter"
          users_obj = User.active.wants_professional_newsletter
          contact_obj = Contact.wants_professional_newsletter
        else        
          users_obj = User.active
          contact_obj = Contact
        end
      end
      all_users = []
      if recipients_general_public
        all_users.concat(contact_obj.all)
      end
      if recipients_full_members
        all_users.concat(users_obj.full_members)
      end
      if recipients_resident_experts
        all_users.concat(users_obj.resident_experts)
      end
      if recipients_free_users
        all_users.concat(users_obj.free_users)
      end
      all_users.each do |u|
        if u.is_a?(User)
          if u.valid?
            puts "Sending email to user #{u.name_with_email}"
            # UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
            UserEmail.create(:user => u, :email_type => "mass_email", :subject => self.subject, :body => self.transformed_body(u),
              :mass_email_id => self.id )
            self.update_attribute(:sent_to, "#{self.sent_to}<br/>#{u.name_with_email}")
          else
            puts "Cannot send an email to user #{u.name_with_email} because this user is not valid. Errors are: #{u.errors.map{|k,v| "#{k}: #{v}"}.to_sentence}"
          end
        else
          #contact
          puts "Sending email to contact #{u.email}"
          # UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
          UserEmail.create(:contact => u, :email_type => "mass_email", :subject => self.subject, :body => self.transformed_body(u),
            :mass_email_id => self.id )
          self.update_attribute(:sent_to, "#{self.sent_to}<br/>#{u.email}")
        end
      end
      self.update_attribute(:sent_at, Time.now)
    end
  end

  def unknown_attributes(user)
    #    errors = []
    #    self.body.split("%").each_with_index do |piece, index|
    #    if index.odd? && !user.attribute_names.include?(piece) && !user.public_methods.include?(piece)
    #        errors << piece
    #      end
    #    end
    #    return errors
    errors =[]
    self.body.scan(/%[a-zA-Z_]+%/) {|s| errors << s[1..s.length-2] if !user.attribute_names.include?(s[1..s.length-2]) && s[1..s.length-2]!= "password" && s[1..s.length-2]!="USER_PROFILE_URL"}
    return errors
  end
  
  def transformed_body(user)
    self.body.gsub(/\n/, "<br/>").gsub(/%[a-zA-Z_]+%/) do |s|
      if s == "%password%"
        #reset password
        r_pass = User.generate_random_password
        user.password = r_pass
        user.password_confirmation = r_pass
        user.save!
        r_pass
      else
        if (s[0].chr == "%") && (s[s.length-1].chr == "%")
          if user.respond_to?(s[1..s.length-2].to_sym)
            user.send(s[1..s.length-2].to_sym)
          else
            if s[1..s.length-2] == "USER_PROFILE_URL"
              "USER_PROFILE_URL"
            end
          end
        end
      end
    end
  end
end
