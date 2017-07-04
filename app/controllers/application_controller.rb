class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private
    def title(page_title)
        @title = page_title.to_s
    end
end
