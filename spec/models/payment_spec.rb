require 'spec_helper'

describe Payment do
  # let (:payment) { FactoryGirl.create :payment }
  let (:payment) do
    Payment.create amount: 5, transaction_id: "derp"
  end

  describe "amazon_cbui_url" do
    specify { payment.amazon_cbui_url( nil ).should == "https://authorize.payments-sandbox.amazon.com/cobranded-ui/actions/start?callerKey=AKIAILELHDMBRXAOPLNA&pipelineName=SingleUse&version=2009-01-09&SignatureVersion=2&SignatureMethod=HmacSHA256&transactionamount=5.0&returnurl=http%3A%2F%2Flocalhost%3A3000%2Famazon_confirm_payment_callback%2F0&callerReference=1&paymentReason=Communificiency%20contribution&Signature=2vG7GltcGc2Escnf%2FcAiFD29ieZuwjE4faaBGIKEHnE%3D" }
  end

end

