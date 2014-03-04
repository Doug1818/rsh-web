class Practice < ActiveRecord::Base
	STATUSES = { invited: 0, inactive: 1, active: 2 }

  attr_accessor :stripe_card_token
  
  has_many :coaches, dependent: :destroy
  has_many :programs, through: :coaches, dependent: :destroy
  has_many :users, through: :programs, dependent: :destroy
  has_many :excuses

  accepts_nested_attributes_for :coaches

  validates :terms, acceptance: true

  after_create :create_excuses

  def create_excuses
    ['Almost', 'Tried', 'Confused', 'Weird Day'].each do |excuse_name|
      self.excuses.create(name: excuse_name)
    end
  end
  def save_with_payment
    # Update or Create stripe customer
    if self.stripe_customer_id?
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)
      customer.card = stripe_card_token
      customer.save
      self.update_attributes(
        stripe_card_type: customer.cards.data[0].type,
        stripe_card_last4: customer.cards.data[0].last4)
    else
      customer = Stripe::Customer.create(
        :card => stripe_card_token,
        # :email => email,
        :description => name)
      self.update_attributes(
        stripe_customer_id: customer.id,
        stripe_card_type: customer.cards.data[0].type,
        stripe_card_last4: customer.cards.data[0].last4)
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
  end
end
