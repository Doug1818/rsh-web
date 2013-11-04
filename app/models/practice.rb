class Practice < ActiveRecord::Base
  has_many :coaches

  accepts_nested_attributes_for :coaches
end
