class UserMailer < ApplicationMailer
  def staff_invitation(user)
    @user = user
    @url = edit_password_reset_url(@user.password_reset_token)

    mail to: @user.email, subject: "You've been invited to join #{@user.account.company_name}"
  end
end
