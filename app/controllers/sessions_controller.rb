class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to user.applicant? ? applicant_portal_path : dashboard_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path, notice: "Logged out."
  end
end