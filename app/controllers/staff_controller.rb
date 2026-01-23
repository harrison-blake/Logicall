class StaffController < ApplicationController
  before_action :require_authentication
  before_action :require_owner_or_admin
  before_action :set_account

  def new
    @user = @account.users.build
  end

  def create
    @user = @account.users.build(staff_params)
    @user.password = SecureRandom.hex(16)

    if @user.save
      @user.generate_password_reset_token!
      UserMailer.staff_invitation(@user).deliver_later
      redirect_to dashboard_path, notice: "Staff member added and invitation sent."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = current_user.account
  end

  def require_owner_or_admin
    unless current_user.owner? || current_user.admin?
      redirect_to dashboard_path, alert: "You are not authorized to perform this action."
    end
  end

  def staff_params
    params.require(:user).permit(:name, :email)
  end
end
