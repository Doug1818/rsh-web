namespace :notification do
  desc "Daily nudge reminder (via push notification)"
  task :nudge_reminder => :environment do
    Program.nudge_reminder
  end
end
