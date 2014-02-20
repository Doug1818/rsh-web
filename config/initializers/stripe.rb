if Rails.env.production?
  Stripe.api_key = "sk_live_Z7yfpHo0N0chGll4IwWBQ9S7"
  ENV['STRIPE_PUBLIC_KEY'] = "pk_live_vMTyMR6p42Qtwix7r1W8OUny"
else
  Stripe.api_key = "sk_test_5VfCOBineyRvm6l07ZAUanJM"
  ENV['STRIPE_PUBLIC_KEY'] = "pk_test_WHUKR5V6wB7I8VdYOOJIBB6v"
end
