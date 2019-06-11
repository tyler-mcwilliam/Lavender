class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:photo])

    # For additional in app/views/devise/registrations/edit.html.erb
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def cents(amount)
    (amount.to_f * 100).to_i
  end

  def user_total_balance
    total_balance_cents = 0
    current_user.groups.each do |group|
      user_share = group.user_groups.where(user_id == current_user.id).user_share
      total_balance_cents += ((group.portfolio_value_cents / group.total_shares) * user_share)
    end
    total_balance_cents = current_user.available_balance_cents + total_balance_cents
  end
end
