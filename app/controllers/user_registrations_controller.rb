class UserRegistrationsController < Devise::RegistrationsController
    protected

    # The path used after sign up for inactive accounts. You need to overwrite
    # this method in your own RegistrationsController.
    def after_inactive_sign_up_path_for(resource)
        scope = Devise::Mapping.find_scope!(resource)
        router_name = Devise.mappings[scope].router_name
        context = router_name ? send(router_name) : self
        context.respond_to?(:root_path) ? context.root_path : '/'
    end

    def sign_up_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
