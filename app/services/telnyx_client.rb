require "net/http"
require "json"

class TelnyxClient
  BASE_URL = "https://api.telnyx.com/v2".freeze
  ELEVENLABS_SIP_URI = "sip.rtc.elevenlabs.io:5060".freeze

  def initialize(account_or_key = nil)
    @api_key = case account_or_key
               when Account then account_or_key.resolved_telnyx_key
               when String then account_or_key
               else Rails.application.credentials.dig(:telnyx, :api_key)
               end
  end

  def configured?
    @api_key.present?
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
    raise "Telnyx is not configured. Add your Telnyx API key in Settings → Account." unless @api_key.present?

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
