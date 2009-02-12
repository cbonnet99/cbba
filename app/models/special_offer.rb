class SpecialOffer < ActiveRecord::Base
  include Workflowable
#  include WhiteListHelper
  belongs_to :author, :class_name => "User"
  after_create :create_slug, :save_pdf_filename, :generate_pdf
  after_update :generate_pdf
  validates_presence_of :title, :description, :how_to_book, :terms
  validates_uniqueness_of :title, :scope => "author_id"
  DEFAULT_TERMS = "<ul><li>Subject to availability at time of application</li><li>Bookings must be made in advance</li><li>Limited to one offer per person</li><li>Not to be used in conjunction with any other offer</li></ul>"
  PDF_SUFFIX_ABSOLUTE = File.dirname(__FILE__) + "/../../public"
  PDF_SUFFIX_RELATIVE = "/special-offers"
  
  def generate_pdf
    FileUtils.mkdir_p(PDF_SUFFIX_ABSOLUTE + pdf_directory)
    pdf = PDF::Writer.new
    pdf.select_font "Times-Roman"
    pdf.fill_color Color::RGB::Blue
    pdf.text title, :justification => :center, :font_size => 24
    pdf.fill_color Color::RGB::Blue
    pdf.text "Special offer description", :justification => :left, :font_size => 18
    pdf.fill_color Color::RGB::Black
    paragraph_text(pdf, description)
#    pdf.text description, :justification => :left, :font_size => 12
    pdf.fill_color  Color::RGB::Blue
    pdf.text "How to book", :justification => :left, :font_size => 18
    pdf.fill_color Color::RGB::Black
    paragraph_text(pdf, how_to_book)
#    pdf.text how_to_book, :justification => :left, :font_size => 12
    pdf.fill_color Color::RGB::Blue
    pdf.text "Terms & conditions", :justification => :left, :font_size => 18
    pdf.fill_color Color::RGB::Black
    paragraph_text(pdf, terms)
#    pdf.text terms, :justification => :left, :font_size => 12
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
  def paragraph_text(pdf, text, paragraph_font_size=12, paragraph_color=Color::RGB::Black)
#    text = white_list(text, {:attributes => ["class"], :tags => %w(strong  p  ul  li)})
    sections = HtmlToPdfConverter.convert(text).split('\n')
    sections.each do |section|
      indent = found_bullet_point(section) ? 10 : 0
      pdf.fill_color! paragraph_color
      pdf.text "#{section}\n", :font_size=>paragraph_font_size, :left=>indent, :justification=>:full
    end
 end

  def found_bullet_point(section)
    /C:bullet/.match(section)
  end
end
