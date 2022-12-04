class NyckelService
  def self.conn
    Faraday.new(url: 'https://www.nyckel.com')
  end

  def self.get_label(comment)
    response = conn.post("/v1/functions/#{ENV['moderation_id']}/invoke") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { data: comment }.to_json
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
