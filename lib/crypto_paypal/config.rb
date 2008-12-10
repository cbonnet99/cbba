module CryptoPaypal
  class Config
    # #IMPORTANT: initialize with dev/test values as the class is reloaded on
    # every request for these environements
    @@paypal_server = "https://www.sandbox.paypal.com/nz/cgi-bin/webscr"
    @@public_certificate="my-pubcert.pem"
    @@private_key="my-prvkey.pem"
    @@paypal_cert_id = "4YTMA47WBP66S"
    @@paypal_business="cbonnet99@gmail.com"

    cattr_accessor :paypal_server, :public_certificate, :private_key, :paypal_certificate, :paypal_cert_id, :paypal_business

  end
end