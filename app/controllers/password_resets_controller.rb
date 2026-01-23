class PasswordResetsController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(password_params)
      @user.update!(password_reset_token: nil, password_reset_sent_at: nil)
      session[:current_user_id] = @user.id
      redirect_to dashboard_path, notice: "Password set successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(password_reset_token: params[:token])
    redirect_to login_path, alert: "Invalid or expired link." unless @user
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
