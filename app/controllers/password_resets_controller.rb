class PasswordResetsController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(password_params)
      session[:current_user_id] = @user.id
      redirect_to dashboard_path, notice: "Password set successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by_token_for(:password_reset, params[:token])
    redirect_to login_path, alert: "Invalid or expired link." unless @user
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
