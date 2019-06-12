class UsersController < ApplicationController
  def new
  end

  def show
    @user = current_user
  end

  def dashboard
    @group = Group.new
    @user_group = UserGroup.new
    @user_groups = current_user.user_groups
    @user = current_user
    @groups = current_user.groups
  end

  def update
    client = Plaid::Client.new(env: :sandbox,
                  client_id: ENV['PLAID_CLIENT_ID'],
                  secret: ENV['PLAID_SECRET'],
                  public_key: ENV['PLAID_PUBLIC_KEY'])

    exchange_token_response = client.item.public_token.exchange(params[:public_token])
    access_token = exchange_token_response['access_token']

    stripe_response = client.processor.stripe.bank_account_token.create(access_token, params[:account_id])
    bank_account_token = stripe_response['stripe_bank_account_token']

    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    charge = Stripe::Charge.create({
      amount: params[:user][:deposit].to_i * 100,
      currency: 'usd',
      source: bank_account_token,
    })

    current_user.available_balance_cents += cents(params[:user][:deposit]) unless params[:user][:deposit].nil? || params[:user][:deposit].to_f < 0
    current_user.available_balance_cents -= cents(params[:user][:withdrawal]) unless params[:user][:withdrawal].nil? || params[:user][:deposit].to_f < 0
    current_user.total_balance_cents += cents(params[:user][:deposit]) unless params[:user][:deposit].nil? || params[:user][:deposit].to_f < 0
    current_user.total_balance_cents -= cents(params[:user][:withdrawal]) unless params[:user][:withdrawal].nil? || params[:user][:deposit].to_f < 0
    current_user.save!
    if @current_user.save
      respond_to do |format|
        format.html { redirect_to dashboard_path }
        format.js
      end
    else
      redirect_to dashboard_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :photo, :photo_cache)
  end
end
