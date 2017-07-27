class StaticPagesController < ApplicationController
    def help
        title("Help - " + params[:page].capitalize)
        render "static/help/#{params[:page]}"
    end

    def show
        title(params[:page].capitalize)
        render "static/#{params[:page]}"
    end
end
