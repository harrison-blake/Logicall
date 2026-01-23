class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    @pending_intakes_count = Intake.pending.count
    @pending_tasks_count = Task.pending.count
    @reviewed_intakes_count = Intake.reviewed.count
    @completed_tasks_count = Task.completed.count
  end
end
