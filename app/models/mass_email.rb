class MassEmail < ActiveRecord::Base

  belongs_to :test_sent_to, :class_name => "User"

  validates_presence_of :subject, :body

  RECIPIENTS = ["Resident experts", "Full members", "Free users", "General public"]

  def send_email(user)
    UserMailer.deliver_mass_email_test(user, self.subject, self.transformed_body(user))
    self.test_sent_at = Time.now
    self.test_sent_to = user
    self.save
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
    self.body.split("%").each_with_index do |piece, index|
      if index.even?
        arr << piece
      else
        arr << user.send(piece.to_sym)
      end
    end
    return arr.join('')
  end
end
