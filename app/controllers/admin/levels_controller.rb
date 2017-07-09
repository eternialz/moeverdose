class Admin::LevelsController < Admin::BaseController
    before_action :set_level, except: [:index]

    def index
        @levels = Kaminari.paginate_array(Level.all).page(params[:page]).per(20)
    end

    def show
    end

    def new
    end

    def edit
    end

    def create
        @level.assign_attributes(level_params)
        last_level = Level.where(final: true).first
        @level.rank = last_level.rank + 1
        last_level.final = false
        @level.final = true
        last_level.save
        if @level.save
            redirect_to admin_levels_path
        else
            render :new
        end
    end

    def update
        @level.assign_attributes(level_params)
        if @level.save
            redirect_to admin_levels_path
        else
            render :edit
        end
    end

    protected

    def level_params
        params.require(:level).permit(:max_exp, :color, :final, :name)
    end

    def set_level
        @level = params[:id] ? Level.find(params[:id]) : Level.new
    end
end
