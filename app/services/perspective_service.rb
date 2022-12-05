class PerspectiveService
  def self.conn
    Faraday.new(url: 'https://commentanalyzer.googleapis.com')
  end

  def self.post_probability(squeak)
    response = conn.post('/v1alpha1/comments:analyze?') do |req|
      req.params = { key: ENV['PERSPECTIVE_KEY'] }
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        comment: { text: squeak },
        languages: ['en'],
        requestedAttributes: { IDENTITY_ATTACK: {} }
      }.to_json
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
