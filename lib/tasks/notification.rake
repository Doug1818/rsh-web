namespace :notification do
  desc "Daily nudge reminder (via push notification)"
  task :nudge_reminder => :environment do
    Program.nudge_reminder
  end

  desc "Scheduled reminders (via push notification)"
  task :scheduled_reminder => :environment do
    Reminder.scheduled_reminder
  end

  desc "Alerts (via push notification)"
  task :check_alerts => :environment do
    Alert.check_alerts
  end

  desc "Weekly more steps reminder (via email)"
  task :more_steps_reminder => :environment do
    Program.more_steps_reminder
  end
end
