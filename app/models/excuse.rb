class Excuse < ActiveRecord::Base
  belongs_to :practice
  has_and_belongs_to_many :check_in_excuses
end
