class SpecialOffer < ActiveRecord::Base
  include Workflowable
  #  include WhiteListHelper
  
  belongs_to :author, :class_name => "User", :counter_cache => true
  belongs_to :subcategory
  has_many :newsletters_special_offers
  has_many :newsletters, :through => :newsletters_special_offers 
  
  after_create :create_slug, :save_pdf_filename, :generate_pdf
  after_update :generate_pdf
  validates_presence_of :title, :description, :how_to_book, :terms
  validates_uniqueness_of :title, :scope => "author_id", :message => "is already used for another of your special offers" 
        
  DEFAULT_TERMS = "<ul><li>Subject to availability at time of application</li><li>Bookings must be made in advance</li><li>Limited to one offer per person</li><li>Not to be used in conjunction with any other offer</li></ul>"
  PDF_SUFFIX_ABSOLUTE = File.dirname(__FILE__) + "/../../public"
  PDF_SUFFIX_RELATIVE = "/assets/special-offers"

  PDF_TEXT_FONT = "Helvetica"
  COLOR_TITLES = Color::RGB::CornflowerBlue
  COLOR_TEXT = Color::RGB::DarkGrey
  TEXT_BOTTOM1 = "This voucher was downloaded from:"
  IMAGE_BOTTOM = "/images/bam-logo.jpg"
  TEXT_BOTTOM2 = "We make having a choice about your wellbeing easy!"

  def short_description
    if description.nil?
      ""
    else
      description[0..300]
    end
  end

  def self.all_offers(user)
    special_offers = SpecialOffer.find_all_by_author_id(user.id, :order => "state, updated_at desc")
    gift_vouchers = GiftVoucher.find_all_by_author_id(user.id, :order => "state, updated_at desc")
    offers = special_offers + gift_vouchers
    offers = offers.sort_by(&:updated_at)
    return offers.reverse!
  end
  
  def self.all_published_offers(user)
    special_offers = SpecialOffer.find_all_by_author_id_and_state(user.id, "published", :order => "published_at desc")
    gift_vouchers = GiftVoucher.find_all_by_author_id_and_state(user.id, "published", :order => "published_at desc")
    offers = special_offers + gift_vouchers
    offers = offers.sort_by(&:published_at)
    return offers.reverse!
  end
  
	def self.count_published_special_offers
	  SpecialOffer.find_all_by_state("published").size
  end

  def generate_pdf
    FileUtils.mkdir_p(PDF_SUFFIX_ABSOLUTE + pdf_directory)
    pdf = PDF::Writer.new
    pdf.select_font PDF_TEXT_FONT
    pdf.fill_color COLOR_TITLES
    pdf.text title, :justification => :center, :font_size => 24
    title_text(pdf, "Special offer description")
    paragraph_text(pdf, description)
    #    pdf.text description, :justification => :left, :font_size => 12
    title_text(pdf, "How to book")
    paragraph_text(pdf, how_to_book)
    #    pdf.text how_to_book, :justification => :left, :font_size => 12
    title_text(pdf, "Terms & conditions")
    paragraph_text(pdf, terms)
    paragraph_text(pdf, "\n")
    pdf.text TEXT_BOTTOM1, :font_size=>12, :justification=>:center
    pdf.image(PDF_SUFFIX_ABSOLUTE+IMAGE_BOTTOM, :justification=>:center)
    pdf.text TEXT_BOTTOM2, :font_size=>12, :justification=>:center
    logger.debug("----- Saving PDF file #{pdf_filename}")
    pdf.save_as(PDF_SUFFIX_ABSOLUTE+pdf_filename)
  end

  def to_param
    slug
  end

  def save_pdf_filename
		self.update_attribute(:filename, pdf_filename)
  end

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		title.parameterize
	end

  def pdf_directory
    "#{PDF_SUFFIX_RELATIVE}/#{author.slug}"
  end

  def pdf_filename
    "#{pdf_directory}/#{slug}.pdf"
  end

  private
  def paragraph_text(pdf, text, paragraph_font_size=12, paragraph_color=COLOR_TEXT)
    #    text = white_list(text, {:attributes => ["class"], :tags => %w(strong  p  ul  li)})
    sections = HtmlToPdfConverter.convert(text).split('\n')
    sections.each do |section|
      indent = found_bullet_point(section) ? 10 : 0
      pdf.fill_color! paragraph_color
      pdf.text "#{section}\n", :font_size=>paragraph_font_size, :left=>indent, :justification=>:full
    end

  end

  def title_text(pdf, text)
    pdf.fill_color! COLOR_TITLES
    pdf.text text, :justification => :left, :font_size => 18

  end
  
  def found_bullet_point(section)
    /C:bullet/.match(section)
  end
end
