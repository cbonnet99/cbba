class MassEmail < ActiveRecord::Base

  belongs_to :test_sent_to, :class_name => "User"

  before_update :assemble_recipients

  validates_presence_of :subject, :body

  RECIPIENTS = {:resident_experts => "Resident experts", :full_members => "Full members",
    :free_users => "Free users", :general_public => "General public"}

  attr_accessor :recipients_resident_experts, :recipients_full_members, :recipients_free_users, :recipients_general_public

  def assemble_recipients
    a = []
    RECIPIENTS.each do |k,v|
      if self.send("recipients_#{k}".to_sym) == "1"
        a << k.to_s
      end
    end
    self.recipients = a.join(',')
  end

  def deliver_test(user)
    UserMailer.deliver_mass_email(user, self.subject, self.transformed_body(user))
    self.test_sent_at = Time.now
    self.test_sent_to = user
    self.save
  end

  def deliver
    unless recipients.blank? || !sent_at.nil?
      recipients.split(',').each do |r|
        if r == "general_public"
          Contact.all.each do |u|
            UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
          end
        else
          User.send(r.to_sym).each do |u|
            UserMailer.deliver_mass_email(u, self.subject, self.transformed_body(u))
          end
        end
      end
      self.update_attribute(:sent_at, Time.now)
    end
  end

  def unknown_attributes(user)
    errors = []
    self.body.split("%").each_with_index do |piece, index|
    if index.odd? && !user.attribute_names.include?(piece) && !user.public_methods.include?(piece)
        errors << piece
      end
    end
    return errors
  end
  
  def transformed_body(user)
    arr = []
    self.body.gsub(/%[a-zA-Z_]+%/) {|s| user.send(s[1..s.length-2].to_sym)}
  end
end
