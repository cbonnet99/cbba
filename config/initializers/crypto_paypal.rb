case RAILS_ENV
when 'development'
  CryptoPaypal::Config.paypal_server = "https://www.sandbox.paypal.com/nz/cgi-bin/webscr"
  CryptoPaypal::Config.public_certificate="dev-pubcert.pem"
  CryptoPaypal::Config.private_key="dev-prvkey.pem"
  CryptoPaypal::Config.paypal_certificate="paypal_cert.pem"
  CryptoPaypal::Config.paypal_cert_id = "AEMR66PBNBDYS"
  CryptoPaypal::Config.paypal_business="cbonnet99@gmail.com"
when'test'
  CryptoPaypal::Config.paypal_server = "https://www.sandbox.paypal.com/nz/cgi-bin/webscr"
  CryptoPaypal::Config.public_certificate="my-pubcert.pem"
  CryptoPaypal::Config.private_key="my-prvkey.pem"
  CryptoPaypal::Config.paypal_certificate="paypal_cert.pem"
  CryptoPaypal::Config.paypal_cert_id = "4YTMA47WBP66S"
  CryptoPaypal::Config.paypal_business="cbonnet99@gmail.com"
when 'production'
  CryptoPaypal::Config.paypal_server = "https://www.paypal.com/nz/cgi-bin/webscr"
  CryptoPaypal::Config.public_certificate="production-pubcert.pem"
  CryptoPaypal::Config.private_key="production-prvkey.pem"
  CryptoPaypal::Config.paypal_certificate="paypal_cert_production.pem"
  CryptoPaypal::Config.paypal_cert_id = "P66P32N232MHL"
  CryptoPaypal::Config.paypal_business="sav@beamazing.co.nz"
end
ActiveMerchant::Billing::PaypalGateway.pem_file =
 File.read(File.dirname(__FILE__) + "/../../paypal/#{CryptoPaypal::Config.paypal_certificate}")
