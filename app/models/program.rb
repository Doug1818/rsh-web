class Program < ActiveRecord::Base
  STATUSES = { inactive: 0, active: 1 }

  belongs_to :user, dependent: :destroy
  belongs_to :coach
  has_many :alerts, dependent: :destroy
  has_many :reminders, dependent: :destroy

  accepts_nested_attributes_for :user
end
