class JwtAuthentication
  SECRET = ENV.fetch("JWT_SECRET", "change_me")

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    token = req.get_header("HTTP_AUTHORIZATION")&.split(" ")&.last
    return unauthorized unless token

    begin
      decoded = JWT.decode(token, SECRET, true, algorithm: 'HS256')
      env["current_service"] = decoded.first
      @app.call(env)
    rescue
      unauthorized
    end
  end

  private

  def unauthorized
    [401, { "Content-Type" => "application/json" }, [{ error: "Unauthorized" }.to_json]]
  end
end
