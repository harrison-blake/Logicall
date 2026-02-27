class AccountsController < ApplicationController
  before_action :require_authentication, only: [ :edit, :update, :onboarding_settings, :add_default_step, :remove_default_step ]
  before_action :require_owner, only: [ :edit, :update, :onboarding_settings, :add_default_step, :remove_default_step ]
  before_action :set_account, only: [ :edit, :update ]

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

  def onboarding_settings
    @account = current_user.account
    @default_onboarding_steps = @account.default_onboarding_steps.order(:position)
  end

  def update
    if @account.update(safe_account_params)
      redirect_to settings_path(tab: params.dig(:account, :gemini_api_key).present? || params.dig(:account, :auto_process_transcripts).present? ? "front_office_ai" : "account"), notice: "Account updated."
    else
      @user = current_user
      @default_onboarding_steps = @account.default_onboarding_steps.order(:position)
      @tab = "account"
      render "settings/show", status: :unprocessable_entity
    end
  end

  def add_default_step
    @account = current_user.account
    @account.default_onboarding_steps.create!(title: params[:title], position: @account.default_onboarding_steps.count)
    redirect_to settings_path(tab: "hiring")
  end

  def remove_default_step
    step = current_user.account.default_onboarding_steps.find(params[:id])
    step.destroy
    redirect_to settings_path(tab: "hiring")
  end

  private

  def set_account
    @account = current_user.account
  end

  def require_owner
    redirect_to dashboard_path, alert: "Only the account owner can access settings." unless current_user.owner?
  end

  def account_params
    params.require(:account).permit(:company_name, :industry, :phone_number, :email, :twilio_phone_number, :auto_process_transcripts, :default_intake_owner_id, :gemini_api_key, :telnyx_api_key)
  end

  def safe_account_params
    account_params.reject { |k, v| %w[gemini_api_key telnyx_api_key].include?(k) && v.blank? }
  end
end
