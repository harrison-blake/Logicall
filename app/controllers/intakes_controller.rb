class IntakesController < ApplicationController
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

  private

  def intake_params
    params.require(:intake).permit(:name, :phone_number, :email, :details, :urgency)
  end
end
