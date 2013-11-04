if Rails.env.production?
  Stripe.api_key = "sk_7iKnt57EtGQyEQvk7dYD03CtGSGfm"
  STRIPE_PUBLIC_KEY = "pk_neubDI84lQmB6lgnlJRD885GqtazV"
else
  Stripe.api_key = "sk_sB4Pq6zuMPutBqOuX0j7CNbzfkXUw"
  STRIPE_PUBLIC_KEY = "pk_sgMGdcpy0H8F1OqdH0J7esjxavF0O"
end
