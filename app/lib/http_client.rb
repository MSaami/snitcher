require "net/http"

class HttpClient
  attr_reader :base_url

  def initialize(base_url)
    @base_url = URI(base_url)
  end

  def get(params = {})
    JSON.parse(Net::HTTP.get(base_url, params))
  rescue => e
    Rails.logger.error(e.message)
    false
  end
end
