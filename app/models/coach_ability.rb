class CoachAbility
  include CanCan::Ability

  def initialize(coach)
    @coach = coach || Coach.new

    role = @coach.role ||= 'guest'
    send(role)
  end

  def guest
    can :create, Practice
    can :update, Practice
    can :update, Coach
  end

  def coach
    guest

    can :edit, Coach, id: @coach.id
    can :show, Coach, id: @coach.id

    can :edit, Program, coach_id: @coach_id
    can :show, Program, coach_id: @coach_id

    can :manage, Alert, program_id: @coach.programs
    can :manage, Todo, program_id: @coach.programs
    can :manage, Reminder, program_id: @coach.programs
    can :manage, Supporter, program_id: @coach.programs

    can :create, Program, coach_id: @coach.id
  end

  def owner
    coach
    can :manage, Practice, id: @coach.practice_id
    can :manage, Coach, practice_id: @coach.practice_id

    can :manage, Program, practice_id: @coach.practice_id
    can :manage, User, coach_id: @coach.users

#   can :update, User, id: @user.id

  end

  def initialize(admin)
    @admin = admin || Admin.new

    role = 'admin'
    send(role)
  end

  def admin
    can :manage, :all
  end
end
