class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    prepend_view_path Rails.root.join('frontend')

    def home
        @news = New.all.order('created_at DESC').limit(2)

        @tags = Tag.popular.limit(20)
        @tags += current_user.favorites_tags if user_signed_in?

        results = TagService.differenciate_tags(@tags)

        @tags = results[:tags]
        @characters = results[:characters]
        @authors = results[:authors]
        @copyrights = results[:copyrights]

        render component 'home'
    end

    def current_user
        @current_user ||= super && User.includes(
            favorites_tags: [:aliases, :main_alias],
            blacklisted_tags: [:aliases, :main_alias]
        ).find(@current_user.id)
    end

    private

    def title(page_title)
        @title = page_title.to_s + ' - ' + helpers.site_name if page_title.to_s != ''
    end

    def items_per_page
        if params[:items_per_page] && @items_per_page_list.max >= params['items_per_page'].to_i
            params['items_per_page'].to_i
        else
            @default_per_page || helpers.default_per_page
        end
    end

    def items_per_page()
        if params[:items_per_page]
            return params["items_per_page"].to_i
        else 
            return @default_per_page || helpers.default_per_page
        end
    end

    def component(component_path)
        path_array = component_path.downcase.split('/')
        name = path_array.pop
        component_name = path_array.join('/')
        "components/#{component_name}/#{name}/_#{name}"
    end

    def xhr_redirect_to(url)
        head 302, x_xhr_redirect_url: url
    end

    def authenticate_user_xhr!
        unless user_signed_in?
<<<<<<< HEAD
            flash[:warning] = "You need to sign in or sign up before continuing."
            xhr_redirect_to(new_user_session_path)
        end
    end
=======
            flash[:warning] = 'You need to sign in or sign up before continuing.'
            xhr_redirect_to(new_user_session_path)
        end
    end

    def set_default_index_values
        @default_per_page = helpers.default_per_page
        @items_per_page_list = helpers.items_per_page_list
        @items_per_page = items_per_page
    end

    def set_custom_index_values(default_per_page, items_per_page_list)
        @default_per_page = default_per_page
        @items_per_page_list = items_per_page_list
        @items_per_page = items_per_page
    end
>>>>>>> develop
end
