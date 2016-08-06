class StaticController < ApplicationController

  def home
    render "static/home"
  end

  def help
    render "static/help/#{params[:page]}"
  end

  def show
    render "static/#{params[:page]}"
  end
end
