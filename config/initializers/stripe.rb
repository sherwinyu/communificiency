Stripe.api_key = Communificiency::Application.config.STRIPE_API_KEY

# STRIPE_API_KEY_TEST = "sk_0D4ItJKUqqLPRZ3vS9A8Mgl6IiHMz" 
# STRIPE_API_KEY_TEST_PUBLIC = "pk_0D4IReQ9k27INskXO9QqIN8nh39bQ" 
# STRIPE_API_KEY_PROD = "sk_0D4IlAP7YQ4Q0uLT43PMe5JCJe9zl"
# STRIPE_API_KEY_PROD_PUBLIC = "pk_0D4ISXBTWRBQFdwygUwzrOXOc6xC4" 

StripeEvent.setup do
  subscribe 'charge.failed' do |event|
    p = Payment.find_by_stripe_charge_id event[:data][:object][:id]
    p.charge_failed! if p
  end

  subscribe 'charge.succeeded' do |event|
    p = Payment.find_by_stripe_charge_id event[:data][:object][:id]
    p.charge_succeeded! if p
  end

  subscribe 'customer.created', 'customer.updated' do |event|
  end

  subscribe do |event|
    puts '\t\t StripeWebhook:', event
  end
end


