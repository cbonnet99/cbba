class MassEmail < ActiveRecord::Base

  belongs_to :test_sent_to, :class_name => "User"
  belongs_to :sent_by, :class_name => "User"
  belongs_to :creator, :class_name => "User"
  belongs_to :newsletter
  
  before_create :check_newsletter

  validates_presence_of :subject 
  validates_presence_of :body, :if => Proc.new {|email| email.email_type == 'Normal'}
  validates_presence_of :newsletter, :if => Proc.new {|email| email.email_type == 'Newsletter'}
    
  TYPES = ["Normal", "Public newsletter", "Business newsletter"]

  RECIPIENTS = ["Full members", "All subscribers"]

  def newsletter?
    email_type == "Public newsletter" || email_type == "Business newsletter"
  end

  def no_recipients?
    recipients.blank?
  end

  def check_newsletter
    if email_type == "Business newsletter"
      self.recipients = "Full members"
    end
    if email_type == "Public newsletter"
      self.recipients = "All subscribers"
    end
  end

  def deliver_test(user)
    res = ""
    if newsletter?
      unless newsletter.published?
        res = "Selected newsletter is not published"
      end
      UserMailer.deliver_mass_email_newsletter(user, self.subject, self.newsletter)
    else
      UserMailer.deliver_mass_email(user, self.subject, self.transformed_body(user))
    end
    self.test_sent_at = Time.now
    self.test_sent_to = user
    self.save
    return res
  end

  def deliver(sender)
    if sent_at.nil?
      if !newsletter.nil? && !newsletter.published?
        newsletter.publish!
      end
      
      case email_type
      when "Public newsletter":
        users_obj = User.active.wants_newsletter
        contact_obj = Contact.active.wants_newsletter
      when "Business newsletter":
          users_obj = User.active.wants_professional_newsletter
          contact_obj = Contact.active.wants_professional_newsletter
      else        
        users_obj = User.active
        contact_obj = Contact.active
      end
      all_users = []
      if recipients == "All subscribers"
        all_users = users_obj.concat(contact_obj.all)
      end
      if recipients == "Full members"
        all_users.concat(users_obj.full_members)
      end
      all_users.each do |u|
        if u.is_a?(User)
          if u.valid?
            puts "Sending email to user #{u.name_with_email}"
            if newsletter?
              UserEmail.create(:user => u, :email_type => "mass_email", :subject => self.subject, :body => nil,
                :mass_email_id => self.id, :newsletter => self.newsletter)                
            else
              UserEmail.create(:user => u, :email_type => "mass_email", :subject => self.subject, :body => self.transformed_body(u),
                :mass_email_id => self.id, :newsletter => nil)
            end
            self.update_attribute(:sent_to, "#{self.sent_to}<br/>#{u.name_with_email}")
          else
            puts "Cannot send an email to user #{u.name_with_email} because this user is not valid. Errors are: #{u.errors.map{|k,v| "#{k}: #{v}"}.to_sentence}"
          end
        else
          #contact
          puts "Sending email to contact #{u.email}"
          if newsletter?
            UserEmail.create(:contact => u, :email_type => "mass_email", :subject => self.subject, :body => nil,
              :mass_email_id => self.id, :newsletter => self.newsletter)                
          else
            UserEmail.create(:contact => u, :email_type => "mass_email", :subject => self.subject, :body => self.transformed_body(u),
              :mass_email_id => self.id, :newsletter => nil)
          end
          self.update_attribute(:sent_to, "#{self.sent_to}<br/>#{u.email}")
        end
      end
      self.update_attributes(:sent_at  => Time.now, :sent_by => sender )
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
