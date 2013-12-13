class AlertDecorator < Draper::Decorator
  delegate_all

  include Draper::LazyHelpers

  def criteria_output
    alert_action_type = Alert::ACTION_TYPES.keys[action_type].downcase
    alert_action_type = alert_action_type.singularize if alert.streak == 1
    alert_sequence = Alert::SEQUENCES.keys[alert.sequence].downcase

    "#{ program.user.first_name } gets #{ streak } #{ alert_action_type } #{ alert_sequence }"
  end
end
