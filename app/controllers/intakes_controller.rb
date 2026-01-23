class IntakesController < ApplicationController
  before_action :require_authentication
  before_action :set_intake, only: [:edit, :update]

  def index
    @intakes = Intake.all
  end

  def new
    @intake = Intake.new
  end

  def create
    @intake = Intake.new(intake_params)
    if @intake.save
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @intake.update(intake_params)
      redirect_to intakes_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_intake
    @intake = Intake.find(params[:id])
  end

  def intake_params
    params.require(:intake).permit(:name, :phone_number, :email, :details, :urgency, :status, :staff_notes)
  end
end
