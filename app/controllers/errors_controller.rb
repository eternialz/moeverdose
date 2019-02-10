class ErrorsController < ApplicationController
    def not_found
        title("Error 404")
        render component("errors/not-found"), status: 404
    end

    def internal_server_error
        title("Error 500")
        render component("errors/internal-server-error"), status: 500
    end

    def error
        title("Error" + (params[:code] || "500"))
        render component("errors/error"), status: params[:code] || 500
    end
end
