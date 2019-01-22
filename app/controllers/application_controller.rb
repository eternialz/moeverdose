class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    def home
        @news = New.all.order('created_at DESC').limit(2)
        render "/home"
    end

    def current_user
        @current_user ||= super && User.includes(favorites_tags: [:aliases, :main_alias], blacklisted_tags: [:aliases, :main_alias]).find(@current_user.id)
    end

    private
    def title(page_title)
        if page_title.to_s != ""
            @title = page_title.to_s + ' - ' + helpers.site_name
        end
    end
end
