class ErrorsController < ApplicationController
    def not_found
      render(:status => 404)
    end

    def internal_server_error
      render(:status => 500)
    end

    def error
        render(:status => params[:code] || 500)
    end
end
