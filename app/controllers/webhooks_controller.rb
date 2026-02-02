class WebhooksController < ApplicationController
  skip_forgery_protection

  def elevenlabs_callback
    payload = JSON.parse(request.body.read)
    Rails.logger.info("ElevenLabs webhook received: #{payload.to_json}")

    return head :ok unless payload["type"] == "post_call_transcription"

    data = payload["data"] || {}
    phone_number = extract_phone_number(data)&.gsub(/\D/, "") # strip non-digits
    account = Account.find_by(twilio_phone_number: phone_number)

    if account
      call_transcript = account.call_transcripts.create!(
        conversation_id: data["conversation_id"],
        caller_phone: extract_caller_phone(data),
        transcript: extract_transcript(data),
        call_duration: data.dig("metadata", "call_duration_secs"),
        status: :completed
      )

      if account.auto_process_transcripts?
        ProcessTranscriptJob.perform_later(call_transcript)
      end
    else
      Rails.logger.warn("No account found for phone number: #{phone_number}")
    end

    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error("Invalid JSON in ElevenLabs webhook: #{e.message}")
    head :bad_request
  end

  private

  def extract_phone_number(data)
    data.dig("metadata", "phone_call", "agent_number")
  end

  def extract_caller_phone(data)
    data.dig("metadata", "phone_call", "external_number")
  end

  def extract_transcript(data)
    transcript_data = data["transcript"]
    return transcript_data if transcript_data.is_a?(String)
    return transcript_data.to_json if transcript_data.is_a?(Hash) || transcript_data.is_a?(Array)
    nil
  end
end
