class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    prepend_view_path Rails.root.join("frontend")

    def home
        @news = New.all.order('created_at DESC').limit(2)

        @tags = Tag.popular.limit(20)
        if user_signed_in?
            @tags += current_user.favorites_tags
        end

        results = TagLogic.differenciate_tags(@tags)

        @tags = results[:tags]
        @characters = results[:characters]
        @authors = results[:authors]
        @copyrights = results[:copyrights]

        render component "home"
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

    def component(component_path)
        path_array = component_path.downcase.split('/')
        name = path_array.pop
        component_name = path_array.join('/')
        return "components/#{component_name}/#{name}/_#{name}"
    end

    def xhr_redirect_to(url)
        head 302, x_xhr_redirect_url: url
    end

    def authenticate_user_xhr!
        unless user_signed_in?
            flash[:warning] = "You need to sign in or sign up before continuing."
            xhr_redirect_to(new_user_session_path)
        end
    end
end
