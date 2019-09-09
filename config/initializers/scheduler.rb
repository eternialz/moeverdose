Rails.configuration.after_initialize do
    if ENV['RAILS_ENV'] != 'test'
        s = Rufus::Scheduler.singleton

        s.schedule '57 22 * * *' do
            TwitterBot.run
        end
    end
end
