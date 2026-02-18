class SettingsController < ApplicationController
  before_action :require_authentication

  def show
    @account = current_user.account
    @user = current_user
    @default_onboarding_steps = @account.default_onboarding_steps.order(:position)
    @tab = if current_user.owner?
             params[:tab] || "account"
           else
             "profile"
           end
  end
end
