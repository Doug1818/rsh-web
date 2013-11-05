class Practice < ActiveRecord::Base
  has_many :coaches
  has_many :programs, through: :coaches
  has_many :users, through: :programs

  accepts_nested_attributes_for :coaches
end
