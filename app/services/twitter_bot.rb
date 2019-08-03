module TwitterBot
    def self.twitter_client
        Twitter::REST::Client.new do |config|
            config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
            config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
            config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
            config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
        end
    end

    def self.run
        if ENV['RAILS_ENV'] == 'production'
            client = twitter_client
            post = Post.where(report: false, :created_at.gt => DateTime.now - 1).order(overdose: :desc, created_at: :desc).first
            if post
                url = Rails.application.routes.url_helpers.post_url(post.number)
                client.update("Best image of the day: #{url}")
            end
        end
    end
end
