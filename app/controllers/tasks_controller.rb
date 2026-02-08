class TasksController < ApplicationController
  before_action :require_authentication
  before_action :require_staff_role
  before_action :set_intake, only: [:create, :update, :destroy]
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.includes(:intake).order(:intake_id, :created_at)
    @tasks = @tasks.where(status: params[:status]) if params[:status].present?
    @tasks_by_intake = @tasks.group_by(&:intake)
  end

  def create
    @task = @intake.tasks.build(task_params)
    if @task.save
      redirect_to edit_intake_path(@intake)
    else
      redirect_to edit_intake_path(@intake), alert: "Could not add task."
    end
  end

  def update
    @task.update(task_params)
    redirect_to edit_intake_path(@intake)
  end

  def destroy
    @task.destroy
    redirect_back fallback_location: tasks_path
  end

  private

  def set_intake
    @intake = Intake.find(params[:intake_id])
  end

  def set_task
    @task = @intake.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:subject, :status)
  end
end
