require 'rufus-scheduler'

Rails.configuration.after_initialize do
    $s = Rufus::Scheduler.singleton

    $s.schedule '57 22 * * *' do
        TwitterBot.run
    end
end

