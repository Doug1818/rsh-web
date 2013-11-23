class BigStep < ActiveRecord::Base
  belongs_to :program
  has_many :small_steps

  def to_s
    "#{name}"
  end
end
