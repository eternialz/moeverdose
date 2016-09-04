class UserRegistrationsController < Devise::RegistrationsController

  protected

  def sign_up_params
    binding.pry
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar, :banner, :website, :facebook, :twitter)
  end
end
