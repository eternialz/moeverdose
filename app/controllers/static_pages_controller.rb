class StaticPagesController < ApplicationController
    def help
        title("Help - " + params[:page].capitalize)
        if user_signed_in?
            render "static/help/#{params[:page]}"
        elsif stale?(params[:page])
            render "static/help/#{params[:page]}"
        end
    end

    def show
        if user_signed_in?
            render "static/#{params[:page]}"
        elsif stale?(params[:page])
            render "static/#{params[:page]}"
        end
    end
end
