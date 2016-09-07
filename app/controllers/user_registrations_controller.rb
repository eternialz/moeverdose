class UserRegistrationsController < Devise::RegistrationsController

  protected

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
