class DashboardController < ApplicationController
  before_action :require_authentication

  def index
    @pending_intakes_count = Intake.pending.count
    @pending_tasks_count = Task.pending.count
    @reviewed_intakes_count = Intake.reviewed.count
    @completed_tasks_count = Task.completed.count
    @call_transcripts_count = current_user.account.call_transcripts.count
    @recent_logs = AssistantLog.order(created_at: :desc).limit(20)
    @recent_calls = current_user.account.call_transcripts.order(created_at: :desc).limit(5)
  end

  def chat
    @prompt = params[:prompt]
    result = GeminiClient.new.chat(@prompt)
    @response = result[:response]

    @logs = result[:actions].map do |action|
      current_user.assistant_logs.create!(
        action_type: action[:tool],
        details: format_action_details(action)
      )
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def format_action_details(action)
    case action[:tool]
    when "create_task"
      "Created task: \"#{action[:result][:subject]}\" for #{action[:result][:intake_name]}"
    when "get_intakes"
      "Retrieved #{action[:result].size} intake(s)"
    when "get_tasks"
      "Retrieved #{action[:result].size} task(s)"
    else
      action[:tool]
    end
  end
end
