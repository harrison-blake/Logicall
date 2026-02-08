class ApplicantsController < ApplicationController
  before_action :require_authentication
  before_action :require_staff_role
  before_action :set_applicant, only: [:edit, :update, :move, :destroy]

  def index
    @applicants = Applicant.includes(:user, :onboarding_steps).all
    @statuses = Applicant.statuses.keys
  end

  def new
    @user = User.new
  end

  def create
    @user = current_user.account.users.build(user_params)
    @user.role = :applicant
    @user.password = SecureRandom.hex(16)

    if @user.save
      applicant = @user.create_applicant_profile!(applicant_params)
      current_user.account.default_onboarding_steps.order(:position).each do |default_step|
        applicant.onboarding_steps.create!(title: default_step.title, position: default_step.position)
      end
      redirect_to applicants_path, notice: "Applicant added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @onboarding_step = OnboardingStep.new
  end

  def update
    if @applicant.update(applicant_params)
      redirect_to edit_applicant_path(@applicant), notice: "Applicant updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @applicant.user.destroy
    redirect_to applicants_path, notice: "Applicant deleted."
  end

  def move
    if @applicant.update(status: params[:status])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def add_step
    @applicant = Applicant.find(params[:applicant_id])
    @applicant.onboarding_steps.create!(title: params[:title], position: @applicant.onboarding_steps.count)
    redirect_to edit_applicant_path(@applicant)
  end

  def toggle_step
    step = OnboardingStep.find(params[:id])
    step.update!(completed: !step.completed)
    redirect_to edit_applicant_path(step.applicant)
  end

  def remove_step
    step = OnboardingStep.find(params[:id])
    applicant = step.applicant
    step.destroy
    redirect_to edit_applicant_path(applicant)
  end

  private

  def set_applicant
    @applicant = Applicant.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def applicant_params
    params.require(:applicant).permit(:position, :notes, :status)
  end
end
