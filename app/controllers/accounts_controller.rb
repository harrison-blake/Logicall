class AccountsController < ApplicationController
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

  private

  def account_params
    params.require(:account).permit(:company_name, :industry, :phone_number, :email)
  end
end
