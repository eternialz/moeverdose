class UserRegistrationsController < Devise::RegistrationsController

  protected

  def sign_up_params
    binding.pry
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
