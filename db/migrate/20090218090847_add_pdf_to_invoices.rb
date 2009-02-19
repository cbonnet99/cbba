class AddPdfToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :pdf, :binary
  end

  def self.down
    remove_column :invoices, :pdf
  end
end
