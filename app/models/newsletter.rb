class Newsletter < ActiveRecord::Base
  include AASM
  belongs_to :author, :class_name => "User"
  belongs_to :publisher, :class_name => "User"
  has_many :newsletters_special_offers
  has_many :special_offers, :through => :newsletters_special_offers
  
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published

  aasm_event :publish do
    transitions :from => :draft, :to => :published, :on_transition => :mark_publish_info 
  end
  aasm_event :retract do
    transitions :to => :draft, :from => :published, :on_transition => :mark_unpublish_info 
  end

  attr_accessor :current_publisher, :special_offers_attributes
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 255

  after_save :save_attributes

  NUMBER_SPECIAL_OFFERS = 3

  def save_attributes
    unless special_offers_attributes.blank?
      self.newsletters_special_offers.destroy_all
      self.special_offers_attributes.each_value do |value|
        sp = SpecialOffer.published.find(value)
        self.special_offers << sp unless sp.nil?
      end
    end
  end

  def selected_offer?(offer, index)
    if self.new_record?
      return index < Newsletter::NUMBER_SPECIAL_OFFERS
    else
      self.special_offers.include?(offer)
    end
  end

  def mark_unpublish_info
    self.published_at = nil
    self.publisher = nil
    self.save!
  end
  
  def mark_publish_info
    self.published_at = Time.now
    self.publisher = self.current_publisher
    self.save!
  end
  
end
