class StaticPagesController < ApplicationController

    def home
        @news = New.limit(2).order(created_at: :desc)
        render "static/home"
    end

    def help
        title("Help - " + params[:page].capitalize)
        render "static/help/#{params[:page]}"
    end

    def show
        title(params[:page].capitalize)
        render "static/#{params[:page]}"
    end
end
