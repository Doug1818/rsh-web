class CheckIn < ActiveRecord::Base
  STATUSES = { none: 0, mixed: 1, all_yes: 2, all_no: 3, future: 4 }
  belongs_to :week
  has_many :activities
  has_and_belongs_to_many :excuses

  def status
    statuses = self.activities.pluck(:status).uniq!
    if statuses.size == 2
      STATUSES[:mixed]
    else
      if statuses[0] == 0
        STATUSES[:all_no]
      elsif statuses[0] == 1
        STATUSES[:all_yes]
      end
    end
  end
end
