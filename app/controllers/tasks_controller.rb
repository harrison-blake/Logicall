class TasksController < ApplicationController
  before_action :require_authentication
  before_action :set_task, only: [:edit, :update]

  def index
    @tasks = Task.includes(:intake)
    @tasks = @tasks.where(status: params[:status]) if params[:status].present?
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:subject, :status, :notes, :urgency)
  end
end
