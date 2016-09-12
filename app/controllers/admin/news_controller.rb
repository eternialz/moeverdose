class Admin::NewsController < Admin::BaseController
  
  before_action :set_new, except: [:index]

  def new
  end

  def index
    @news = New.all
  end

  def show
  end

  def edit
  end

  def create
    @new.assign_params(new_params)
    if @new.save
      redirect_to admin_news(@new)
    else
      render :new
    end
  end

  def update
    @new.assign_params(new_params)
    if @new.save
      redirect_to admin_news(@new)
    else
      render :new
    end
  end

  def destroy
    @new.delete
    redirect_to admin_news_index_path
  end

  protected

  def set_new
    @new = params[:id] ? New.find(params[:id]) : New.new
  end

  def new_params
    parmas.require(:news).permit(:title, :text)
  end

end
