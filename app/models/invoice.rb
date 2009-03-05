require 'pdf/writer'
require 'pdf/simpletable'

class Invoice < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :payment

  after_create :create_filename, :generate_pdf

  INVOICE_PREFIX="INV-"
  INVOICE_NUMBER_LENGTH=6
  PDF_SUFFIX_ABSOLUTE = File.dirname(__FILE__) + "/../../public"
  PDF_SUFFIX_RELATIVE = "/invoices"
  IMAGE_LOGO = "/images/bam-logo.jpg"

  PDF_TEXT_FONT = "Helvetica"
  COLOR_TITLES = Color::RGB::CornflowerBlue
  COLOR_TEXT = Color::RGB::DarkGrey

  def create_filename
    update_attribute(:filename, "#{invoice_number}.pdf")
  end

  def invoice_number
    "#{INVOICE_PREFIX}#{self.id.to_s.rjust(INVOICE_NUMBER_LENGTH, '0')}"
  end

  def generate_pdf
    pdf = PDF::Writer.new
    pdf.select_font PDF_TEXT_FONT
    pdf.image(PDF_SUFFIX_ABSOLUTE+IMAGE_LOGO, :justification=>:left)
    pdf.text "From:", :font_size => 16
    pdf.text "BeAmazing Ltd", :font_size => 12
    pdf.text "40 Woodward Street"
    pdf.text "Featherston, Sth Wairarapa"
    pdf.text "GST number: 101-412-473"
    pdf.text "Bank account: Kiwibank 38-9008-0791899-00"
    pdf.text "To:", :font_size => 16
    pdf.text payment.user.full_name, :font_size => 12
    pdf.text payment.user.contact_details.gsub(/<br\/>/, "\n")
    
    PDF::SimpleTable.new do |table|
        table.title_font_size = 16
        table.title_color = COLOR_TITLES
        table.title = "Invoice #{invoice_number}"
        table.column_order.push(*%w(description price))

        table.columns["description"] = PDF::SimpleTable::Column.new("description") { |col|
          col.heading = "Description"
        }
        table.columns["price"] = PDF::SimpleTable::Column.new("price") { |col|
          col.heading = "Price"
          col.justification = :right
        }
        table.show_lines    = :all
        table.show_headings = true
        table.orientation   = :center
        table.position      = :center

        data = [
          { "description" => "#{payment.title}", "price" => amount_view(payment.amount)},
          { "description" => "GST", "price" => amount_view(payment.gst)},
          { "description" => "Total", "price" => amount_view(payment.total)}
        ]

        table.data.replace data
        table.render_on(pdf)
    end
    self.update_attribute(:pdf, pdf.render)
  end

end
