class CallTranscriptsController < ApplicationController
  before_action :require_authentication

  def index
    @call_transcripts = current_user.account.call_transcripts.order(created_at: :desc)
  end

  def show
    @call_transcript = current_user.account.call_transcripts.find(params[:id])
  end
end
