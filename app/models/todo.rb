class Todo < ActiveRecord::Base
  STATUSES = { incomplete: 0, complete: 1}

  belongs_to :program
  has_one :user, through: :program
end
