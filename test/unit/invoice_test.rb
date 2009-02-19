require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Invoice.new.valid?
  end
  def test_filename
    inv = Invoice.create(:payment => payments(:completed))
    assert inv.filename.start_with?(Invoice::INVOICE_PREFIX)
  end

  def test_generate_pdf
    inv = Invoice.create(:payment => payments(:completed))
    inv.generate_pdf
    assert_not_nil inv.pdf
  end
end
