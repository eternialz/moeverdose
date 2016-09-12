class StaticPagesController < ApplicationController

  def home
    @news = New.limit(2).order(created_at: :desc)
    render "static/home"
  end

  def help
    render "static/help/#{params[:page]}"
  end

  def show
    render "static/#{params[:page]}"
  end
end
