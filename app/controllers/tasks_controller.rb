class TasksController < ApplicationController
  def index
    @tasks = Task.includes(:intake).all
  end
end
