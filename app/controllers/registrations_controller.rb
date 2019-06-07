class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    # raise
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :photo, :photo_cache, :address)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :photo, :photo_cache, :address)
  end
end
