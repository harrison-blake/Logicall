require "net/http"
require "json"

class GeminiClient
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent".freeze

  SYSTEM_INSTRUCTION = <<~PROMPT
    You are a helpful AI assistant for a healthcare front office platform.
    You can have normal conversations AND help with work tasks.

    For casual messages (greetings, general questions), just respond naturally without using any tools.

    Only use tools when the user asks about intakes, tasks, or wants to create/manage data:
    - Intakes: Patient intake forms with details about why they're requesting an appointment.
    - Tasks: Action items for staff to complete for each intake.

    When asked to create tasks for an intake, analyze the patient's details and create relevant,
    specific tasks. For example:
    - "chronic back pain" → tasks like "Request prior imaging records", "Verify insurance for specialist visit"
    - "annual checkup" → tasks like "Send appointment confirmation email", "Prepare patient history summary"
  PROMPT

  TOOLS = {
    "get_intakes" => {
      declaration: {
        name: "get_intakes",
        description: "Returns patient intakes. Use status filter to get pending (need review) or reviewed (completed) intakes.",
        parameters: {
          type: "object",
          properties: {
            status: { type: "string", enum: %w[pending reviewed], description: "Filter by intake status" }
          }
        }
      },
      execute: ->(args) {
        scope = args["status"] ? Intake.where(status: args["status"]) : Intake.all
        scope.select(:id, :name, :email, :phone_number, :urgency, :details, :status).as_json
      }
    },
    "get_tasks" => {
      declaration: {
        name: "get_tasks",
        description: "Returns tasks. Use status filter to get pending (todo) or completed tasks.",
        parameters: {
          type: "object",
          properties: {
            status: { type: "string", enum: %w[pending completed], description: "Filter by task status" }
          }
        }
      },
      execute: ->(args) {
        scope = args["status"] ? Task.where(status: args["status"]) : Task.all
        scope.includes(:intake).map { |t| { id: t.id, subject: t.subject, status: t.status, intake_name: t.intake.name } }
      }
    },
    "create_task" => {
      declaration: {
        name: "create_task",
        description: "Creates a new task for a specific intake. Use this when the user wants to add a task or action item for a patient.",
        parameters: {
          type: "object",
          properties: {
            intake_id: { type: "integer", description: "The ID of the intake to add the task to" },
            subject: { type: "string", description: "The task description (e.g., 'Call patient', 'Verify insurance')" }
          },
          required: %w[intake_id subject]
        }
      },
      execute: ->(args) {
        intake = Intake.find_by(id: args["intake_id"])
        return { error: "Intake not found" } unless intake
        task = intake.tasks.create!(subject: args["subject"], status: :pending)
        { success: true, task_id: task.id, subject: task.subject, intake_name: intake.name }
      }
    }
  }.freeze

  def initialize(api_key = ENV["GEMINI_API_KEY"])
    @api_key = "AIzaSyBzGLh28YxISwhfZ4fV0lgqAEOkYAoX9ts"
  end

  def chat(prompt)
    if needs_tools?(prompt)
      chat_with_tools(prompt)
    else
      { response: generate(prompt), actions: [] }
    end
  end

  def chat_with_tools(prompt)
    contents = [{ role: "user", parts: [{ text: prompt }] }]
    actions = []

    loop do
      response = call_api(contents)
      parts = response.dig("candidates", 0, "content", "parts") || []

      function_call = parts.find { |p| p.key?("functionCall") }
      text_part = parts.find { |p| p.key?("text") }

      if function_call
        func_name = function_call["functionCall"]["name"]
        func_args = function_call["functionCall"]["args"] || {}
        result = execute_function(func_name, func_args)

        actions << { tool: func_name, args: func_args, result: result }

        contents << { role: "model", parts: [{ functionCall: function_call["functionCall"] }] }
        contents << { role: "user", parts: [{ functionResponse: { name: func_name, response: { result: result } } }] }
      elsif text_part
        return { response: text_part["text"], actions: actions }
      else
        return { response: "I'm not sure how to help with that.", actions: actions }
      end
    end
  end

  def needs_tools?(prompt)
    keywords = %w[intake intakes task tasks patient patients create add show list pending reviewed completed]
    words = prompt.downcase.split(/\W+/)
    result = words.any? { |word| keywords.include?(word) }
    Rails.logger.info "NEEDS_TOOLS? prompt=#{prompt.inspect} words=#{words.inspect} result=#{result}"
    result
  end

  def generate(prompt)
    response = call_api([{ role: "user", parts: [{ text: prompt }] }], tools: false)
    response.dig("candidates", 0, "content", "parts", 0, "text")
  end

  private

  def call_api(contents, tools: true)
    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["x-goog-api-key"] = @api_key

    body = {
      contents: contents,
      system_instruction: { parts: [{ text: SYSTEM_INSTRUCTION }] }
    }
    if tools
      body[:tools] = [{ function_declarations: TOOLS.values.map { |t| t[:declaration] } }]
      body[:tool_config] = { function_calling_config: { mode: "AUTO" } }
    end

    request.body = body.to_json

    response = http.request(request)
    result = JSON.parse(response.body)

    unless response.is_a?(Net::HTTPSuccess)
      raise "Gemini API error: #{result["error"]["message"]}"
    end

    result
  end

  def execute_function(name, args = {})
    tool = TOOLS[name]
    raise "Unknown function: #{name}" unless tool
    tool[:execute].call(args)
  end
end
