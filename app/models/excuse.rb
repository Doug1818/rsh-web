class Excuse < ActiveRecord::Base
  GLOBAL_EXCUSES = ["Was on vacation", "Too tired", "Dog ate homework"]
  belongs_to :practice
  has_and_belongs_to_many :check_ins
end
