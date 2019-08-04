class Admin::PermissionsTypesController < Admin::BaseController
    def index
        @permissions_types = PermissionsType.all
        render component 'admin/permissions_types/index'
    end

    def new
        @permissions_type = PermissionsType.new
        render component 'admin/permissions_types/new'
    end

    def create
        @permissions_type = PermissionsType.new(permissions_type_params)
        if @permissions_type.save
            flash[:success] = 'Processing created'
            redirect_to admin_permissions_types_path
        else
            flash[:error] = 'An error occured'
            redirect_to new_admin_permissions_types_path
        end
    end

    def destroy
        @permissions_type = PermissionsType.find(params[:id])
        @permissions_type.destroy
        xhr_redirect_to admin_permissions_types_path
    end

    def permissions_type_params
        params.require(:permissions_type).permit(:name, :description)
    end
end
