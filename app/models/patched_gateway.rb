class PatchedGateway < ActiveMerchant::Billing::PaymentExpressGateway

  def store(credit_card, options = {})
    request  = build_token_request(credit_card, options)
    commit(:authorization, request)
  end

end