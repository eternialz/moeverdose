class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    prepend_view_path Rails.root.join("frontend")

    def home
        @news = New.all.order('created_at DESC').limit(2)
        render component "home"
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
end
