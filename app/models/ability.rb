class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    role_name = @user.role.present? ? @user.role : "guest"

    send(role_name)
  end

  def guest
    # can :index, :home
  end

  def member
    guest
  end

  def coach
    member
  end

  def admin
    can :manage, :all
  end
end
