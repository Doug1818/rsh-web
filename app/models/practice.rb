class Practice < ActiveRecord::Base
	STATUSES = { invited: 0, inactive: 1, active: 2 }
  
  has_many :coaches, dependent: :destroy
  has_many :programs, through: :coaches, dependent: :destroy
  has_many :users, through: :programs, dependent: :destroy
  has_many :excuses

  accepts_nested_attributes_for :coaches

  validates :terms, acceptance: true

  before_create :create_excuses

  def create_excuses
    ['Almost', 'Tried', 'Confused', 'Weird Day'].each do |excuse_name|
      self.excuses.create(name: excuse_name)
    end
  end
end
