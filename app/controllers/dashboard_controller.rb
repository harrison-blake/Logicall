class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    @intakes_count = Intake.count
    @tasks_count = Task.count
  end
end
