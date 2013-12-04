class BigStep < ActiveRecord::Base
  belongs_to :program
  has_many :small_steps

  def to_s
    "#{name}"
  end

  def as_json(options={})
    {
      id: self.id,
      text: self.name
    }
  end
end
