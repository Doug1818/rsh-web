class CoachAbility
  include CanCan::Ability

  def initialize(coach)
    @coach = coach || Coach.new

    role = @coach.role ||= 'guest'
    send(role)
  end

  def guest
    can :create, Practice
  end

  def coach
    guest
    can :edit, Coach, id: @coach.id
    can :show, Coach, id: @coach.id
  end

  def owner
    coach
    can :manage, Practice, id: @coach.practice_id
    can :manage, Coach, practice_id: @coach.practice_id
#   can :update, User, id: @user.id

  end
end
