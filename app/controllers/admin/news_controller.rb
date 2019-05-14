class Admin::NewsController < Admin::BaseController

    before_action :set_new, except: [:index]

    def new
        render component "admin/news/new"
    end

    def index
        @news = Kaminari.paginate_array(New.all.order('created_at DESC')).page(params[:page]).per(20)

        render component "admin/news/index"
    end

    def show
        render component "admin/news/show"
    end

    def edit
        render component "admin/news/edit"
    end

    def create
        @new.assign_attributes(new_params)
        if @new.save
            redirect_to admin_news_path(@new)
        else
            render :new
        end
    end

    def update
        @new.assign_attributes(new_params)
        if @new.save
            redirect_to admin_news_path(@new)
        else
            render :edit
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
        params.require(:news).permit(:title, :text)
    end

end
