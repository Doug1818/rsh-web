class Ability
  include CanCan::Ability

  def initialize(user)
    role = (user && user.role) ? user.role : 'guest'
    send(role)
  end

  def guest
  end

  def coach
    guest
    can :index, :coaches_home
  end

  def owner
    coach
  end
end
