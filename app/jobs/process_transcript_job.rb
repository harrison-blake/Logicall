class ProcessTranscriptJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 3, wait: :polynomially_longer

  def perform(call_transcript)
    return unless call_transcript.account.auto_process_transcripts?
    return if call_transcript.intake.present?

    TranscriptProcessor.new(call_transcript).process
  end
end
