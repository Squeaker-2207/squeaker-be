class NyckelService
  def self.conn
    Faraday.new(url: 'https://www.nyckel.com')
  end
  def self.get_label(squeak)
    Rails.cache.fetch("#{squeak}-content") do
      response = conn.post("/v1/functions/#{ENV['MODERATION_ID']}/invoke") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = { data: squeak }.to_json
      end
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
