class MassEmail < ActiveRecord::Base

  belongs_to :test_sent_to, :class_name => "User"

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
      if email_type =~ /newsletter/
        users_obj = User.wants_newsletter
        contact_obj = Contact.wants_newsletter
      else
        users_obj = User
        contact_obj = Contact
      end
      if recipients_general_public
        contact_obj.all.each do |u|
          UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
        end
      end
      if recipients_full_members
        users_obj.full_members.each do |u|
          UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
        end
      end
      if recipients_resident_experts
        users_obj.resident_experts.each do |u|
          UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
        end
      end
      if recipients_free_users
        users_obj.free_users.each do |u|
          UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
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
    self.body.scan(/%[a-zA-Z_]+%/) {|s| errors << s[1..s.length-2] if !user.attribute_names.include?(s[1..s.length-2])}
    return errors
  end
  
  def transformed_body(user)
    arr = []
    self.body.gsub(/%[a-zA-Z_]+%/) do |s|
      if s == "%password%"
        #reset password
        r_pass = User.generate_random_password
        user.update_attributes(:password => r_pass, :confirm_password => r_pass)
      else
        puts "==== #{s[0]} #{s[s.length-1]} #{user.respond_to?(s[1..s.length-2].to_sym)}"
        if (s[0] == "%") && (s[s.length-1] == "%") && user.respond_to?(s[1..s.length-2].to_sym)
          user.send(s[1..s.length-2].to_sym)
        end
      end
    end
  end
end
