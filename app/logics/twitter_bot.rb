class TwitterBot
    def self.run
        post = Post.where(report: false, :created_at.gt => DateTime.now - 1).order(overdose: :desc, created_at: :desc).first
        url = Rails.application.routes.url_helpers.post_url(post.number)
        $client.update("Best image of the day: #{url}")
        
    end

end
