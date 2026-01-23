class UsersController < ApplicationController
  before_action :set_account, only: [:new, :create]

	def new
		@user = @account.users.build
	end

	def create
    	@user = @account.users.build(user_params)
    	@user.role = "owner"

    	if @user.save
      		session[:current_user_id] = @user.id
      		redirect_to dashboard_path
    	else
      		render :new, status: :unprocessable_entity
    	end
	end

	private
    def set_account
        @account = Account.find(params[:account_id])
  	    rescue ActiveRecord::RecordNotFound
        redirect_to new_account_path, alert: "Account not found. Please register your company first."
    end

	def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end