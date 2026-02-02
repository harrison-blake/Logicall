class TranscriptProcessor
  def initialize(call_transcript)
    @call_transcript = call_transcript
    @account = call_transcript.account
    @gemini = GeminiClient.new
  end

  def process
    return if @call_transcript.intake.present?

    transcript_text = format_transcript
    patient_info = extract_patient_info(transcript_text)
    intake = create_intake(patient_info)
    tasks = generate_tasks(transcript_text, patient_info)
    create_tasks(intake, tasks)
    @call_transcript.update!(intake: intake)

    intake
  end

  private

  def format_transcript
    transcript = @call_transcript.transcript
    return transcript if transcript.is_a?(String)

    parsed = transcript.is_a?(String) ? JSON.parse(transcript) : transcript
    return transcript.to_s unless parsed.is_a?(Array)

    parsed.map { |turn| "#{turn['role']&.capitalize}: #{turn['message']}" }.join("\n")
  rescue JSON::ParserError
    transcript.to_s
  end

  def extract_patient_info(transcript_text)
    prompt = <<~PROMPT
      Analyze this healthcare call transcript and extract patient information.
      Return ONLY a JSON object with these fields (use null for missing info):
      - name: patient's full name
      - phone: patient's phone number
      - email: patient's email if mentioned
      - details: brief summary of why they're calling
      - urgency: "low", "medium", or "high" based on the nature of the call

      Transcript:
      #{transcript_text}
    PROMPT

    response = @gemini.generate(prompt)
    parse_json_response(response, default_patient_info)
  end

  def generate_tasks(transcript_text, patient_info)
    prompt = <<~PROMPT
      Based on this healthcare call transcript, generate a list of specific follow-up tasks.
      These should be actionable items for staff, specific to what was discussed.
      Do NOT include generic tasks - make them specific to this call.

      Return ONLY a JSON array of task descriptions, e.g.:
      ["Call patient back about lab results", "Schedule MRI for left knee"]

      Patient: #{patient_info[:name] || "Unknown"}
      Reason: #{patient_info[:details] || "Unknown"}

      Transcript:
      #{transcript_text}
    PROMPT

    response = @gemini.generate(prompt)
    parse_json_response(response, [])
  end

  def create_intake(patient_info)
    owner = @account.default_intake_owner || @account.users.find_by(role: :owner)

    Intake.create!(
      user: owner,
      name: patient_info[:name] || "Unknown Caller",
      phone_number: patient_info[:phone] || @call_transcript.caller_phone,
      email: patient_info[:email],
      details: patient_info[:details] || "Auto-generated from call transcript",
      urgency: map_urgency(patient_info[:urgency]),
      status: :pending
    )
  end

  def create_tasks(intake, task_subjects)
    return unless task_subjects.is_a?(Array)

    task_subjects.each do |subject|
      next if subject.blank?
      intake.tasks.create!(subject: subject, status: :pending)
    end
  end

  def parse_json_response(response, default)
    return default if response.blank?

    json_match = response.match(/```(?:json)?\s*([\s\S]*?)\s*```/) || response.match(/(\{[\s\S]*\}|\[[\s\S]*\])/)
    json_str = json_match ? json_match[1] : response

    result = JSON.parse(json_str)
    result.is_a?(Hash) ? result.symbolize_keys : result
  rescue JSON::ParserError
    Rails.logger.error("Failed to parse AI response: #{response}")
    default
  end

  def default_patient_info
    { name: nil, phone: nil, email: nil, details: nil, urgency: nil }
  end

  def map_urgency(urgency_str)
    case urgency_str&.downcase
    when "high" then "high"
    when "medium" then "medium"
    else "low"
    end
  end
end
