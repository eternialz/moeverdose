class StaticController < ApplicationController

  def help
    render "static/help/#{params[:page]}"
  end

  def show
    render "static/#{params[:page]}"
  end
  
end
