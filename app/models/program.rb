class Program < ActiveRecord::Base
  STATUSES = { inactive: 0, active: 1 }

  belongs_to :user
  belongs_to :coach

  accepts_nested_attributes_for :user
end
