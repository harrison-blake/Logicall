require "net/http"
require "json"

class TelnyxClient
  BASE_URL = "https://api.telnyx.com/v2".freeze
  ELEVENLABS_SIP_URI = "sip.rtc.elevenlabs.io:5060".freeze

  def initialize(api_key = Rails.application.credentials.dig(:telnyx, :api_key))
    @api_key = api_key
  end

  def answer_call(call_control_id)
    post("/calls/#{call_control_id}/actions/answer", {})
  end

  def transfer_to_elevenlabs(call_control_id:, caller_phone:, account_phone:)
    sip_headers = [
      { name: "X-Caller-Phone", value: caller_phone },
      { name: "X-Account-Phone", value: account_phone }
    ]

    post("/calls/#{call_control_id}/actions/transfer", {
      to: "sip:#{account_phone}@#{ELEVENLABS_SIP_URI}",
      sip_headers: sip_headers,
      timeout_secs: 30
    })
  end

  private

  def post(path, body)
    uri = URI("#{BASE_URL}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@api_key}"
    request.body = body.to_json

    response = http.request(request)
    result = JSON.parse(response.body)

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("Telnyx API error: #{result}")
      raise "Telnyx API error: #{result["errors"]&.first&.dig("detail") || "Unknown error"}"
    end

    result
  end
end
