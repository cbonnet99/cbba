class GiftVouchersNewsletter < ActiveRecord::Base
  belongs_to :newsletter
  belongs_to :gift_voucher
end
