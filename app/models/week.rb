class Week < ActiveRecord::Base
  belongs_to :program
  has_and_belongs_to_many :small_steps
  has_many :check_ins

  accepts_nested_attributes_for :small_steps, :reject_if => :all_blank, :allow_destroy => true
end
