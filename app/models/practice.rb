class Practice < ActiveRecord::Base
  has_many :coaches, dependent: :destroy
  has_many :programs, through: :coaches, dependent: :destroy
  has_many :users, through: :programs, dependent: :destroy
  has_many :excuses

  accepts_nested_attributes_for :coaches

  validates :terms, acceptance: true
end
