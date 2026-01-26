class AccountsController < ApplicationController
  before_action :require_authentication, only: [:edit, :update]
  before_action :require_owner, only: [:edit, :update]
  before_action :set_account, only: [:edit, :update]

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to new_account_user_path(@account)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to edit_account_path(@account), notice: "Account updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = current_user.account
  end

  def require_owner
    redirect_to dashboard_path, alert: "Only the account owner can access settings." unless current_user.owner?
  end

  def account_params
    params.require(:account).permit(:company_name, :industry, :phone_number, :email, :twilio_phone_number)
  end
end
