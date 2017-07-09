class ErrorsController < ApplicationController
    def not_found
        title("404")
        render(:status => 404)
    end

    def internal_server_error
        title("500")
        render(:status => 500)
    end

    def error
        title(params[:code].to_s || "500")
        render(:status => params[:code] || 500)
    end
end
